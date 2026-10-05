import Foundation

/**
 * Singleton facade — the app-wide entry point. One call sets everything up;
 * identification is automatic (the SDK calls your `getUser` after connecting
 * and on every reconnect), so there is no manual identify() to call:
 *
 *   Smartico.initialize(labelKey: "<your-label-key>", options: SmarticoOptions(
 *       brandKey: "<your-brand-key>",
 *       getUser: { isLoggedIn() ? SmarticoUser(extUserId: extUserId, hash: hash) : nil }
 *   ))
 *   let levels = try await Smartico.api.getLevels()
 *
 * For multiple labels in one app, construct `SmarticoConnection` directly.
 *
 * A caseless enum is the Swift spelling of a Kotlin `object`; `init` is not a
 * legal static method name, hence `initialize`.
 */
public enum Smartico {

    private static let connectionBox = LockedBox<SmarticoConnection?>(nil)

    private static var connection: SmarticoConnection? { connectionBox.get() }

    /**
     * Facade-level listener registry. Subscriptions must survive re-init (a
     * host may re-identify after a profile change, which replaces the
     * connection) — so the facade owns them and re-attaches every time.
     */
    private static let listeners = ListenerRegistry()

    /** Open the connection. Re-initialising closes the previous socket first. */
    @discardableResult
    public static func initialize(labelKey: String, options: SmarticoOptions = SmarticoOptions()) -> SmarticoConnection {
        bootstrapEngagements() // register the internal cid-110 consumer once
        let conn = SmarticoConnection(labelKey: labelKey, options: options)
        let previous = connectionBox.withLock { c -> SmarticoConnection? in
            let p = c
            c = conn
            return p
        }
        previous?.close()
        // Re-attach persistent facade subscriptions to the fresh connection.
        // "engagement" stays facade-only: the cid-110 consumer re-emits every
        // FRESH engagement under that name itself, and the connection fires the
        // same name for every raw 110 — attaching there too delivered each fresh
        // engagement twice (and duplicates once).
        for l in listeners.all() where l.event != .name("engagement") { conn.on(l.event, token: l.token, l.cb) }
        conn.connect()
        return conn
    }

    /** The typed data surface — e.g. `Smartico.api.getLevels()`. */
    public static var api: SmarticoApi { require().api }

    /** The underlying connection (raw requests, publicProps, …). */
    public static var raw: SmarticoConnection { require() }

    /** Subscribe to a server push, by friendly name ("props_change", …) or raw cid.
     * Safe to call before initialize(); survives re-init (re-attached automatically).
     * Callbacks run on the main queue. */
    @discardableResult
    public static func on(_ event: SmarticoEvent, _ cb: @escaping (JSONObject) -> Void) -> SubscriptionToken {
        let token = listeners.add(event, cb)
        if event != .name("engagement") { connection?.on(event, token: token, cb) } // see initialize(): facade-only event
        return token
    }

    /** Unsubscribe a callback previously registered with `on`. */
    public static func off(_ token: SubscriptionToken) {
        listeners.remove(token)
        connection?.off(token)
    }

    /** Snapshot of the user's public properties (points, level, inbox count…). */
    public static func getPublicProps() async -> [String: JSON] {
        await require().getPublicProps()
    }

    /** Public label setting from INIT_RESPONSE (CDN URLs, feature flags…). */
    public static func getLabelSetting(_ key: String) async -> JSON? {
        await require().getLabelSetting(key)
    }

    /** Send a client event, e.g. `event("client_action", payload: ["action": "opened_shop"])`. */
    @discardableResult
    public static func event(_ eventType: String, payload: JSONObject = [:]) async throws -> JSONObject {
        guard let conn = connection else { throw SmarticoError.notInitialized }
        return try await conn.event(eventType, payload: payload)
    }

    /** Log the current user out (also clears the popup queue and dedupe). */
    public static func logout() {
        connection?.logout()
        engagements.clear() // user boundary: pending popups die with the session
    }

    /** Change the user's public display name (persists server-side). */
    public static func changeUsername(_ publicUsername: String) async throws -> String? {
        guard let conn = connection else { throw SmarticoError.notInitialized }
        return try await conn.changeUsername(publicUsername)
    }

    /** Forward a pre-built protocol message to the socket (native-bridge bcid 6). */
    public static func sendRaw(_ message: JSONObject) {
        require().sendRaw(message)
    }

    /** Register a native push token (cid 1003); platform from PushPlatform. */
    public static func registerPushToken(_ token: String, platform: Int, appPackageId: String? = nil) {
        require().registerPushToken(token, platform: platform, appPackageId: appPackageId)
    }

    /** Push reports fired before identify (cold-start taps) — flushed on identify. */
    private static let pendingPushReports = LockedBox<[(PushEngagementEventType, PushEngagementRef)]>([])

    /**
     * Report push lifecycle analytics: delivered / impression / action / failed.
     * Safe to call at any time — before initialize/identify the report is queued
     * and flushed as soon as a user is identified.
     */
    public static func reportPushEngagement(_ type: PushEngagementEventType, ref: PushEngagementRef) {
        if let conn = connection, !conn.extUserId.isEmpty {
            Task { await conn.reportPushEngagement(type, ref: ref) }
        } else {
            pendingPushReports.withLock { $0.append((type, ref)) }
        }
    }

    // ---- Engagement popups (cid 110, activityType 30) ------------------------

    /** Deduped queue of pending popups; the SDK feeds it from cid 110 itself. */
    private static let engagements = EngagementQueue()
    private static let engagementsBootstrapped = LockedBox(false)
    private static let lastIdentifiedExtUserId = LockedBox("")

    /**
     * Internal cid-110 consumer, registered through the persistent facade
     * registry so it survives re-init like any app subscription:
     *  - dedupes by engagement_uid (the server re-delivers on every identify);
     *  - re-emits every FRESH engagement (any activityType) as the facade-level
     *    "engagement" event — subscribe to that instead of raw 110;
     *  - queues activityType 30 (popups) for the host's popup UI;
     *  - clears everything on a user boundary (identify as a different user).
     */
    private static func bootstrapEngagements() {
        let first = engagementsBootstrapped.withLock { done -> Bool in
            if done { return false }
            done = true
            return true
        }
        if !first { return }

        on("identify") { _ in
            let ext = connection?.extUserId ?? ""
            let changed = lastIdentifiedExtUserId.withLock { last -> Bool in
                if ext == last { return false }
                last = ext
                return true
            }
            if changed { engagements.clear() }
            // Flush push reports queued before identify (cold-start taps).
            let pending = pendingPushReports.withLock { list -> [(PushEngagementEventType, PushEngagementRef)] in
                let all = list
                list.removeAll()
                return all
            }
            if let conn = connection {
                for (type, ref) in pending {
                    Task { await conn.reportPushEngagement(type, ref: ref) }
                }
            }
        }

        on(110) { msg in
            if engagements.isDuplicate(engagementUid(msg)) { return }
            for cb in listeners.callbacks(for: "engagement") { cb(msg) }
            let at = (msg["activityType"] ?? msg["activity_type"])?.int
            if at == 30 { engagements.offer(msg) }
        }
    }

    /** Number of popups waiting to be shown. */
    public static func pendingEngagements() -> Int {
        engagements.size
    }

    /** Take the next pending popup (nil when none). The host decides WHEN. */
    public static func takeEngagement() -> EngagementPayload? {
        engagements.take()
    }

    /** Subscribe to popup-queue changes. Returns unsubscribe. */
    public static func onEngagementsChanged(_ fn: @escaping () -> Void) -> () -> Void {
        engagements.onChange(fn)
    }

    /** The shared engagement dedupe — for other engagement-bearing pushes (cid 105). */
    public static func isDuplicateEngagement(_ uid: String) -> Bool {
        engagements.isDuplicate(uid)
    }

    // The two sessions forward bcid 6 through `connection?.sendRaw` rather than
    // `sendRaw` above: Kotlin wraps the call in runCatching (reporting is
    // best-effort), and a Swift fatalError cannot be caught.

    /** Drive one popup's wrapper-page conversation (see PopupBridgeSession). */
    public static func createPopupSession(payload: EngagementPayload, hooks: PopupSessionHooks) -> PopupBridgeSession {
        PopupBridgeSession(payload: payload, hooks: hooks, sendRaw: { connection?.sendRaw($0) }, runDp: { dp($0) })
    }

    /** Drive one hosted widget's native-bridge conversation (see WidgetBridgeSession). */
    public static func createWidgetSession(hooks: WidgetSessionHooks) -> WidgetBridgeSession {
        WidgetBridgeSession(hooks: hooks, sendRaw: { connection?.sendRaw($0) }, runDp: { dp($0) })
    }

    // ---- Deep links ("dp:") --------------------------------------------------

    private static let dpRouter = DpRouter(sendClientAction: { action in
        Task { _ = try? await event("client_action", payload: ["action": .string(action)]) }
    })

    /** Inject the app's UI bindings (screen navigation, URL/widget opening). */
    public static func configureDp(_ bindings: DpBindings) {
        dpRouter.configure(bindings)
    }

    /** Register a custom dp handler for operator-specific actions. Returns unregister. */
    public static func registerDpHandler(_ fn: @escaping DpHandler) -> () -> Void {
        dpRouter.register(fn)
    }

    /** Execute a deep link. Returns false if nothing handled it. */
    @discardableResult
    public static func dp(_ raw: String) -> Bool {
        dpRouter.run(raw)
    }

    /** Internal: the connection, or a fatal error if initialize() hasn't run yet. */
    private static func require() -> SmarticoConnection {
        guard let conn = connection else { fatalError("Smartico.initialize must be called first") }
        return conn
    }
}
