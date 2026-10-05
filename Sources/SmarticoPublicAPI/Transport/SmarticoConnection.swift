import Foundation

/**
 * Headless Smartico transport.
 *
 * It owns the WebSocket and drives the Smartico connection protocol:
 *  - the INIT(3) → IDENTIFY(5) → LOGIN(7) lifecycle,
 *  - queues outgoing messages behind an "identified" gate,
 *  - correlates responses to requests by uuid (with a cid fallback — the
 *    server does NOT echo the request uuid for every response type),
 *  - keeps the connection alive with PING/PONG (29s of silence → PING),
 *  - resets and reconnects on close.
 *
 * Threading model: all mutable state lives inside this actor — the Swift form
 * of the Kotlin single-thread `loop` dispatcher — so the protocol state machine
 * never races with itself. URLSession callbacks and the `nonisolated` entry
 * points hop in through an ordered mailbox (one `AsyncStream` drained by one
 * task): a bare `Task { await … }` per call would not preserve the order the
 * calls were made in, while Kotlin's `scope.launch` onto a single-thread
 * dispatcher does. Listener callbacks are delivered on the main queue, in
 * order.
 */
public actor SmarticoConnection {
    /** A unit of work posted from outside the actor; runs on it, in posting order. */
    typealias Job = @Sendable (isolated SmarticoConnection) -> Void

    // -- state (actor-isolated unless marked nonisolated) ---------------------

    private nonisolated let labelKey: String
    private nonisolated let opts: SmarticoOptions

    /** The ordered hop into the actor (see the type comment). */
    private nonisolated let mailbox: AsyncStream<Job>.Continuation

    private nonisolated let session: URLSession
    private var ws: URLSessionWebSocketTask? {
        didSet { liveSocket.set(ws) }
    }
    /** `ws`, readable from deinit (which is not actor-isolated). */
    private nonisolated let liveSocket = LockedBox<URLSessionWebSocketTask?>(nil)
    private var socketOpen = false

    /** Outgoing messages; `toIdentified` ones wait behind the identify gate. */
    private struct Queued {
        let toIdentified: Bool
        let fields: JSONObject
    }

    private var queue: [Queued] = []

    private struct Pending {
        let continuation: CheckedContinuation<JSONObject, Error>
        let expectCid: Int
        let timeout: Task<Void, Never>
    }

    /** Insertion-ordered: the cid-fallback correlation picks the OLDEST waiter. */
    private var pending: [String: Pending] = [:]
    /** The keys of `pending`, oldest first (Swift dictionaries have no order). */
    private var pendingOrder: [String] = []

    /** Listener registry; key = friendly name or raw cid. */
    private nonisolated let listeners = ListenerRegistry()

    /** Public properties (points, level, inbox count…), identify + cid-108 pushes. */
    private var publicProps: [String: JSON] = [:]
    private var labelSettings: JSONObject = [:]

    private nonisolated let extUserIdBox = LockedBox("")

    /** ext_user_id of the current identify session ("" before identify / after logout). */
    public nonisolated var extUserId: String { extUserIdBox.get() }

    private var identified = false
    private var closedByUser = false
    private nonisolated let deviceId: String

    private var keepalive: Task<Void, Never>?
    private var flusher: Task<Void, Never>?

    /** The label key this connection serves (avatar/CDN URL derivation). */
    public nonisolated let label: String

    /** The brand this connection identifies under, when the label has brands. */
    public nonisolated let brandKey: String?

    public init(labelKey: String, options: SmarticoOptions = SmarticoOptions()) {
        self.labelKey = labelKey
        self.opts = options
        self.label = labelKey
        self.brandKey = options.brandKey
        self.deviceId = options.deviceId ?? guid()

        var cont: AsyncStream<Job>.Continuation!
        let stream = AsyncStream<Job>(bufferingPolicy: .unbounded) { cont = $0 }
        let mailbox: AsyncStream<Job>.Continuation = cont
        self.mailbox = mailbox
        self.session = URLSession(
            configuration: .default,
            delegate: SocketDelegate(post: { (job: @escaping Job) in mailbox.yield(job) }),
            delegateQueue: nil
        )

        // The mailbox pump. Holds the connection only while a job runs, so a
        // connection nobody references any more is released (deinit below).
        Task { [weak self] in
            for await job in stream {
                guard let self = self else { return }
                await self.perform(job)
            }
        }
    }

    deinit {
        mailbox.finish()
        // A connection released with its socket still up leaves with a close
        // frame (1001; a no-op when close() already sent 1000), and
        // finishTasksAndInvalidate lets URLSession finish that closing
        // handshake before the session — and its delegate — go away.
        liveSocket.get()?.cancel(with: .goingAway, reason: nil)
        session.finishTasksAndInvalidate()
    }

    private func perform(_ job: Job) {
        job(self)
    }

    private nonisolated func post(_ job: @escaping Job) {
        mailbox.yield(job)
    }

    // -- public surface -------------------------------------------------------

    /**
     * The typed data surface — `connection.api.getLevels()`, …
     *
     * A fresh, stateless wrapper per access (Kotlin caches it `by lazy`): a
     * cached one would hold the connection strongly from inside it — a cycle
     * ARC never collects.
     */
    public nonisolated var api: SmarticoApi { SmarticoApi(conn: self) }

    /** Open the socket. Sends INIT on open and starts draining the queue. */
    public nonisolated func connect() {
        post { $0.doConnect() }
    }

    /** Stop the connection and timers for good (no reconnect). */
    public nonisolated func close() {
        // The job holds the connection until it has run: Smartico.initialize
        // closes the previous connection and drops it at once, and the 1000
        // close frame must still go out before deinit tears the session down.
        post { [self] conn in
            withExtendedLifetime(self) {}
            conn.closedByUser = true
            conn.flusher?.cancel(); conn.flusher = nil
            conn.keepalive?.cancel(); conn.keepalive = nil
            conn.ws?.cancel(with: .normalClosure, reason: nil)
        }
    }

    /**
     * Subscribe to a server push. `event` is a friendly name ("props_change",
     * "engagement", …) or a raw ClassId Int. The callback receives the full
     * message (e.g. for "props_change" the points are in `msg["props"]`).
     * Callbacks run on the main queue, in the order the messages arrived.
     */
    @discardableResult
    public nonisolated func on(_ event: SmarticoEvent, _ cb: @escaping (JSONObject) -> Void) -> SubscriptionToken {
        listeners.add(event, cb)
    }

    /** Attach under an existing token — how the facade re-attaches its subscriptions. */
    nonisolated func on(_ event: SmarticoEvent, token: SubscriptionToken, _ cb: @escaping (JSONObject) -> Void) {
        listeners.add(event, token: token, cb)
    }

    /** Unsubscribe a callback previously registered with `on`. */
    public nonisolated func off(_ token: SubscriptionToken) {
        listeners.remove(token)
    }

    /**
     * Snapshot of the user's public properties (points, level, inbox count…),
     * accumulated from the identify response and props_change pushes.
     */
    public func getPublicProps() -> [String: JSON] {
        publicProps
    }

    /** Public label setting from INIT_RESPONSE (CDN URLs, feature flags…). */
    public func getLabelSetting(_ key: String) -> JSON? {
        labelSettings[key]
    }

    /**
     * Send a data request and await its response — the building block every
     * typed api method sits on. The wire envelope is
     * api_key/brand_key/[ext_user_id]/cid/uuid/ts + payload, and the message is
     * held in the queue until the user is identified.
     */
    public func request(
        cid: Int,
        expectCid: Int,
        payload: JSONObject = [:],
        extUserId: String? = nil
    ) async throws -> JSONObject {
        let uuid = guid()
        let msg = envelope(cid, uuid, payload, extUserId)
        let timeoutNs = UInt64(max(0, opts.requestTimeoutMs)) * 1_000_000
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<JSONObject, Error>) in
            let timeout = Task { [weak self] in
                try? await Task.sleep(nanoseconds: timeoutNs)
                if Task.isCancelled { return }
                await self?.requestTimedOut(uuid, cid: cid)
            }
            pending[uuid] = Pending(continuation: continuation, expectCid: expectCid, timeout: timeout)
            pendingOrder.append(uuid)
            queue.append(Queued(toIdentified: true, fields: msg))
        }
    }

    private func requestTimedOut(_ uuid: String, cid: Int) {
        if let entry = removePending(uuid) {
            entry.continuation.resume(throwing: SmarticoError.timeout(cid: cid))
        }
    }

    /** Fire-and-forget variant of `request` (no response expected). */
    public nonisolated func send(cid: Int, payload: JSONObject = [:], extUserId: String? = nil) {
        let msg = envelope(cid, guid(), payload, extUserId)
        post { $0.queue.append(Queued(toIdentified: true, fields: msg)) }
    }

    /**
     * Forward a pre-built protocol message over the socket, fire-and-forget.
     * Used for ready-made messages from the native-bridge WebView (bcid 6
     * SEND_TO_SOCKET — e.g. engagement impression cid 103 / action cid 104).
     * Fills uuid/ts when missing; held until identified.
     */
    public nonisolated func sendRaw(_ message: JSONObject) {
        var fields: JSONObject = [
            "uuid": .string(guid()),
            "ts": JSON(nowMs()),
        ]
        for (k, v) in message { fields[k] = v } // caller's fields win
        let msg = fields
        post { $0.queue.append(Queued(toIdentified: true, fields: msg)) }
    }

    /**
     * Register a native push token (cid 1003): {token, platform,
     * pushNotificationUserStatus: 0 (ALLOWED), app_package_id}. Queued until
     * identify, so the server binds the token to the identified user.
     */
    public nonisolated func registerPushToken(_ token: String, platform: Int, appPackageId: String? = nil) {
        if token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
        sendRaw([
            "cid": JSON(Cid.REGISTER_PUSH_TOKEN),
            "token": .string(token),
            "platform": JSON(platform),
            "pushNotificationUserStatus": 0,
            "app_package_id": JSON(appPackageId),
        ])
    }

    /**
     * Report a push notification's lifecycle event (delivered / impression /
     * action / failed) over the papi HTTP endpoint — guide §5. HTTP because at
     * tap-time the socket may not exist. Needs an identified user, or an
     * explicit `userExtId` (cold-start tap before identify).
     */
    @discardableResult
    public func reportPushEngagement(
        _ type: PushEngagementEventType,
        ref: PushEngagementRef,
        userExtId: String? = nil
    ) async -> Bool {
        let ext = userExtId ?? extUserId
        if ext.isEmpty || ref.engagementUid.isEmpty { return false }
        var payload: JSONObject = [
            "engagement_uid": .string(ref.engagementUid),
        ]
        if let messageId = ref.messageId { payload["message_id"] = .string(messageId) }
        payload["activity_type"] = 40
        if type == .action, let action = ref.action { payload["action"] = .string(action) }
        let event: JSON = [
            "uuid": .string(guid()),
            "ts": JSON(nowMs()),
            "event_type": .string(type.wire),
            "user_ext_id": .string(ext),
            "payload": .object(payload),
        ]
        var q = "api_key=" + enc(labelKey)
        if let brand = opts.brandKey { q += "&brand_key=" + enc(brand) }
        q += "&version=" + PAPI_REPORT_VERSION
        q += "&event=" + enc(event.jsonString())
        do {
            let ok = try await httpGet("\(Env.publicUrl(labelKey))?\(q)")
            log("push report", type.wire, ref.engagementUid, ok ? "ok" : "http error")
            return ok
        } catch {
            log("push report failed", "\(error)")
            return false
        }
    }

    /**
     * Change the user's public display name (cid 159/160). Persists server-side
     * and comes back in publicProps; the server does NOT push props_change for
     * it, so we emit a synthetic one to keep host state layers in sync.
     */
    public func changeUsername(_ publicUsername: String) async throws -> String? {
        let r = try await request(
            cid: Cid.SET_CUSTOM_USERNAME,
            expectCid: Cid.SET_CUSTOM_USERNAME_RESPONSE,
            payload: ["public_username_custom": .string(publicUsername)]
        )
        let name = r["public_username_custom"]?.string
        if let name = name {
            // The protocol request only STORES the name — it emits nothing the
            // gamification engine can see. Missions that track "changed the
            // nickname" listen for this separate client event instead, so it has
            // to be sent explicitly; without it the name changes while the
            // mission stays at 0.
            sendClientEvent("gf_nickname_changed")
            publicProps["public_username"] = .string(name)
            emit([
                "cid": 108,
                "props": ["public_username": .string(name)],
            ])
        }
        return name
    }

    /**
     * Fire-and-forget client event (cid 9, no response awaited) — the shape the
     * gamification engine expects for the events a client reports by itself.
     */
    nonisolated func sendClientEvent(_ eventType: String, payload: JSONObject = [:]) {
        send(cid: Cid.EVENT, payload: [
            "eventType": .string(eventType),
            "payload": .object(payload),
        ])
    }

    /** Send a client event, e.g. `event("client_action", payload: ["action": "opened_shop"])`. */
    @discardableResult
    public func event(_ eventType: String, payload: JSONObject = [:]) async throws -> JSONObject {
        try await request(cid: Cid.EVENT, expectCid: Cid.EVENT_RESPONSE, payload: [
            "eventType": .string(eventType),
            "payload": .object(payload),
        ])
    }

    /**
     * Log the current user out (sends LOGOUT) and clear user state locally.
     * The socket stays open.
     */
    public nonisolated func logout() {
        post { conn in
            conn.sendLifecycle(Cid.LOGOUT, ["payload": .object([:])])
            conn.extUserIdBox.set("")
            conn.publicProps.removeAll()
        }
    }

    // -- internals ------------------------------------------------------------

    private func doConnect() {
        closedByUser = false
        // The backend checks NO HTTP headers here and ignores `domain`; the
        // query params are kept because the endpoint expects their shape.
        let url = opts.wsUrl ?? (
            Env.wsUrl(labelKey)
                + "?master&domain=" + enc(opts.domain ?? "")
                + "&version=" + enc(opts.version ?? SDK_VERSION)
        )
        log("connecting to", url)
        guard let u = URL(string: url) else {
            log("socket error", "invalid url \(url)")
            return
        }

        // A second connect() while a socket is up replaces it; the old task's
        // late callbacks are ignored (they no longer match `ws`).
        ws?.cancel(with: .goingAway, reason: nil)
        let task = session.webSocketTask(with: u)
        // URLSession caps inbound messages at 1 MiB by default; OkHttp has no
        // such cap, and large maps (missions, translations) must not kill the
        // socket.
        task.maximumMessageSize = 64 * 1024 * 1024
        ws = task
        receive(on: task)
        task.resume()

        // Single drain loop — the only place queued messages hit the socket.
        if flusher == nil {
            flusher = Task { [weak self] in
                while !Task.isCancelled {
                    guard await self?.flush() != nil else { return }
                    try? await Task.sleep(nanoseconds: 10_000_000)
                }
            }
        }
    }

    /**
     * Read one message, hand it to the actor, re-arm: URLSessionWebSocketTask
     * delivers exactly one message per `receive` call. A receive failure means
     * the socket is gone.
     */
    private nonisolated func receive(on task: URLSessionWebSocketTask) {
        task.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.post { $0.socketDidReceive(task, text) }
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.post { $0.socketDidReceive(task, text) }
                    }
                @unknown default:
                    break
                }
                self.receive(on: task)
            case .failure(let error):
                self.post { $0.socketDidEnd(task, error) }
            }
        }
    }

    // URLSession → actor. Every callback names its task; anything from a task
    // that is no longer `ws` (replaced, or already closed) is ignored, so the
    // several ways URLSession reports one close (didCloseWith, the failing
    // receive, didCompleteWithError) collapse into a single handleClose.

    fileprivate func socketDidOpen(_ task: URLSessionWebSocketTask) {
        guard task === ws else { return }
        handleOpen()
    }

    fileprivate func socketDidReceive(_ task: URLSessionWebSocketTask, _ text: String) {
        guard task === ws else { return }
        handleMessage(text)
    }

    fileprivate func socketDidClose(_ task: URLSessionWebSocketTask, _ code: URLSessionWebSocketTask.CloseCode, _ reason: Data?) {
        guard task === ws else { return }
        ws = nil
        handleClose(closeDetail(code, reason))
    }

    fileprivate func socketDidEnd(_ task: URLSessionWebSocketTask, _ error: Error?) {
        guard task === ws else { return }
        ws = nil
        if let error = error, task.closeCode == .invalid {
            let msg = error.localizedDescription
            log("socket error", msg)
            handleClose("failure=\(msg)")
        } else {
            handleClose(closeDetail(task.closeCode, task.closeReason))
        }
    }

    private nonisolated func closeDetail(_ code: URLSessionWebSocketTask.CloseCode, _ reason: Data?) -> String {
        let text = reason.flatMap { String(data: $0, encoding: .utf8) } ?? ""
        return "code=\(code.rawValue) reason=\(text.isEmpty ? "(none)" : text)"
    }

    private func handleOpen() {
        socketOpen = true
        log("socket open")
        sendLifecycle(Cid.INIT, initPayload())
    }

    /** The INIT (cid 3) payload. */
    nonisolated func initPayload() -> JSONObject {
        let cleanKey = Env.cleanLabelKey(labelKey)
        return [
            "label_name": .string(cleanKey),
            "label_key": .string(cleanKey),
            "brand_key": JSON(opts.brandKey),
            "simulation_mode": false,
            "device_id": .string(deviceId),
            "page": .string("https://\(opts.domain ?? "app")/"),
            "tracker_version": .string(opts.version ?? SDK_VERSION),
            // session_id MUST be a non-empty string: an empty one makes the
            // backend reject the connection AND block the client IP for
            // ~60 min. Never send an empty one.
            "session_id": .string(guid()),
        ]
    }

    /** Lifecycle/keepalive messages bypass the identified gate. */
    private func sendLifecycle(_ cid: Int, _ data: JSONObject) {
        var fields: JSONObject = [
            "cid": JSON(cid),
            "uuid": .string(guid()),
            "ts": JSON(nowMs()),
        ]
        for (k, v) in data { fields[k] = v }
        queue.append(Queued(toIdentified: false, fields: fields))
    }

    /** Ask the app for the current user (getUser) and send IDENTIFY automatically. */
    private func runIdentify() {
        guard let provider = opts.getUser else { return } // no provider → stay anonymous
        // Kotlin also logs "getUser threw" here; the Swift provider type is
        // non-throwing (a failing provider returns nil), so there is nothing to catch.
        Task { [weak self] in
            let user = await provider()
            await self?.identify(as: user)
        }
    }

    private func identify(as user: SmarticoUser?) {
        if let user = user, !user.extUserId.isEmpty, !user.hash.isEmpty {
            extUserIdBox.set(user.extUserId)
            sendLifecycle(Cid.IDENTIFY, [
                "ext_user_id": .string(user.extUserId),
                "hash": .string(user.hash),
            ])
        }
    }

    /** Drain the queue: send every message that is allowed to go right now. */
    private func flush() {
        guard let socket = ws, socketOpen else { return }
        if queue.isEmpty { return }
        var kept: [Queued] = []
        for m in queue {
            let allowed = !m.toIdentified || identified // ← the "gate"
            if !allowed {
                kept.append(m)
                continue
            }
            let frame = JSON.object(m.fields).jsonString(sortedKeys: false)
            socket.send(.string(frame)) { [weak self] error in
                if let error = error { self?.log("send failed", error.localizedDescription) }
            }
            let cid = m.fields["cid"]?.int
            if opts.traceFrames && cid != Cid.PING && cid != Cid.PONG { log("OUT", frame) }
        }
        queue = kept
    }

    private func handleMessage(_ raw: String) {
        guard let obj = (try? JSON.parse(raw))?.object else { return }
        guard let cid = obj["cid"]?.int else { return }

        // keepalive
        if cid == Cid.PING { sendLifecycle(Cid.PONG, [:]) }
        if cid != Cid.PONG { scheduleKeepalive() }
        if opts.traceFrames && cid != Cid.PING && cid != Cid.PONG { log("IN", JSON.object(obj).jsonString()) }

        // accumulate public props from any message that carries them
        if let props = obj["props"]?.object {
            for (k, v) in props { publicProps[k] = v }
        }

        let errCode = obj["errCode"]?.int

        // lifecycle responses drive the state machine
        switch cid {
        case Cid.INIT_RESPONSE:
            if errCode == 0 {
                // INIT_RESPONSE carries the public label settings (CDN URLs,
                // feature flags…).
                if let settings = obj["settings"]?.object { labelSettings = settings }
                runIdentify() // SDK calls getUser() itself, then sends IDENTIFY
            } else {
                log("INIT failed", JSON.object(obj).jsonString())
            }
            return

        case Cid.IDENTIFY_RESPONSE:
            if errCode == 0 {
                // Identity fields ride at the TOP LEVEL of the identify
                // response, not inside props — mirror them into publicProps
                // (user_id is needed by avatar APIs; native_app_gf_url is the
                // server-built widget wrapper URL).
                for k in ["user_id", "avatar_id", "avatar_real_id", "public_username", "native_app_gf_url"] {
                    if let v = obj[k], !v.isNull { publicProps[k] = v }
                }
                identified = true // ← opens the queue gate
                sendLifecycle(Cid.LOGIN, ["payload": .object([:])])
                // Surface identification: a dedicated 'identify' event plus a
                // synthetic props_change with the merged snapshot — otherwise
                // consumers would have to poll for the identify gap.
                fire("identify", obj)
                emit([
                    "cid": 108,
                    "props": .object(publicProps),
                ])
            } else {
                log("IDENTIFY failed", JSON.object(obj).jsonString())
            }
            return

        case Cid.LOGIN_RESPONSE:
            log("session active")
            return

        default:
            break
        }

        // Request/response correlation. The server echoes the request uuid for
        // some responses but NOT all (e.g. SAW_GET_SPINS_RESPONSE arrives with a
        // fresh uuid) — match by uuid first, then fall back to the oldest
        // request awaiting this cid (`pendingOrder` preserves insertion order).
        let uuid = obj["uuid"]?.string
        var key: String? = uuid.flatMap { pending[$0] != nil ? $0 : nil }
        if key == nil {
            key = pendingOrder.first { pending[$0]?.expectCid == cid }
        }
        if let key = key, let entry = removePending(key) {
            entry.timeout.cancel()
            entry.continuation.resume(returning: obj)
            return
        }

        // otherwise it's a server-initiated push → hand it to subscribers.
        emit(obj)
    }

    private func removePending(_ uuid: String) -> Pending? {
        guard let entry = pending.removeValue(forKey: uuid) else { return nil }
        if let i = pendingOrder.firstIndex(of: uuid) { pendingOrder.remove(at: i) }
        return entry
    }

    /** Fire a push to subscribers — by raw cid and by its friendly name. */
    func emit(_ obj: JSONObject) {
        guard let cid = obj["cid"]?.int else { return }
        fire(.cid(cid), obj)
        if let name = PUSH_EVENT_NAMES[cid] { fire(.name(name), obj) }
    }

    /**
     * Deliver to the subscribers of `key` on the main queue. The subscriber
     * list is read when the block runs, so an `off` made on the main thread
     * before delivery is honoured. (Kotlin wraps each call in a try/catch
     * "listener threw"; Swift callbacks are non-throwing.)
     */
    func fire(_ key: SmarticoEvent, _ obj: JSONObject) {
        let registry = listeners
        DispatchQueue.main.async {
            for cb in registry.callbacks(for: key) { cb(obj) }
        }
    }

    private func handleClose(_ detail: String) {
        socketOpen = false
        log("socket closed", detail)
        queue.removeAll()
        // fail in-flight requests instead of silently dropping their awaiters
        let failing = pendingOrder.compactMap { pending[$0] }
        pending.removeAll()
        pendingOrder.removeAll()
        for entry in failing {
            entry.timeout.cancel()
            entry.continuation.resume(throwing: SmarticoError.connectionClosed)
        }
        identified = false
        keepalive?.cancel(); keepalive = nil
        if opts.reconnect && !closedByUser {
            Task { [weak self] in
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await self?.reconnect()
            }
        }
    }

    /** The delayed reconnect; a close() that landed during the delay wins. */
    private func reconnect() {
        if closedByUser { return }
        doConnect()
    }

    private func scheduleKeepalive() {
        keepalive?.cancel()
        keepalive = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(NO_MESSAGE_TIMER_MS) * 1_000_000)
            if Task.isCancelled { return }
            await self?.keepaliveFired()
        }
    }

    private func keepaliveFired() {
        // Re-checked on the actor: a message that arrived while this task was
        // hopping in has already cancelled it and armed a fresh one.
        if Task.isCancelled { return }
        sendLifecycle(Cid.PING, [:])
        scheduleKeepalive()
    }

    /** Request envelope: api_key/brand_key/[ext_user_id]/cid/uuid/ts + payload. */
    nonisolated func envelope(_ cid: Int, _ uuid: String, _ payload: JSONObject, _ extUserId: String?) -> JSONObject {
        var o: JSONObject = ["api_key": .string(labelKey)]
        if let brand = opts.brandKey { o["brand_key"] = .string(brand) }
        if let ext = extUserId { o["ext_user_id"] = .string(ext) }
        o["cid"] = JSON(cid)
        o["uuid"] = .string(uuid)
        o["ts"] = JSON(nowMs())
        for (k, v) in payload { o[k] = v }
        return o
    }

    /**
     * HTTPS GET returning parsed JSON — for the protocol's non-socket paths
     * (inbox message bodies on the CDN, avatar customization). Nil on any
     * transport/parse failure.
     */
    public nonisolated func httpGetJson(_ url: String) async -> JSONObject? {
        guard let u = URL(string: url) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: u)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { return nil }
            return (try? JSON.parse(data))?.object
        } catch {
            return nil
        }
    }

    /** HTTPS POST with a JSON body, returning parsed JSON (avatar API). */
    public nonisolated func httpPostJson(_ url: String, body: JSONObject) async -> JSONObject? {
        guard let u = URL(string: url) else { return nil }
        var req = URLRequest(url: u)
        req.httpMethod = "POST"
        req.httpBody = JSON.object(body).data(sortedKeys: false)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            return (try? JSON.parse(data))?.object
        } catch {
            return nil
        }
    }

    /** GET; true on a 2xx. Network failures are `false`; a malformed URL throws. */
    private nonisolated func httpGet(_ url: String) async throws -> Bool {
        guard let u = URL(string: url) else { throw URLError(.badURL) }
        do {
            let (_, response) = try await URLSession.shared.data(from: u)
            return (response as? HTTPURLResponse).map { (200..<300).contains($0.statusCode) } ?? false
        } catch {
            return false
        }
    }

    private nonisolated func enc(_ s: String) -> String {
        formUrlEncode(s)
    }

    nonisolated func log(_ args: String...) {
        if opts.debug { smarticoLog("[Smartico] " + args.joined(separator: " ")) }
    }
}

/**
 * URLSession's delegate for the socket. An actor cannot be an `NSObject`, so
 * this small object forwards each callback into the connection's mailbox; it
 * holds the mailbox, never the connection (no retain cycle through URLSession,
 * which keeps its delegate alive).
 */
private final class SocketDelegate: NSObject, URLSessionWebSocketDelegate, @unchecked Sendable {
    private let post: @Sendable (@escaping SmarticoConnection.Job) -> Void

    init(post: @escaping @Sendable (@escaping SmarticoConnection.Job) -> Void) {
        self.post = post
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        post { $0.socketDidOpen(webSocketTask) }
    }

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        post { $0.socketDidClose(webSocketTask, closeCode, reason) }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let ws = task as? URLSessionWebSocketTask else { return }
        post { $0.socketDidEnd(ws, error) }
    }
}
