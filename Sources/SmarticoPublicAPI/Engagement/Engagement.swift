import Foundation

/**
 * Engagement (popup) handling — protocol layer, shared semantics for every
 * native SDK. The SDK owns the deduped queue and the wrapper-page bcid
 * handshake; the host app owns the WebView, animations and the show-policy
 * (when to take the next popup).
 */
public typealias EngagementPayload = JSONObject

/** engagement_uid of a cid-110 / cid-105 push ("" when the server sent none). */
public func engagementUid(_ msg: JSONObject) -> String {
    (msg["engagement_uid"] ?? msg["engagement_id"])?.string ?? ""
}

/**
 * Deduped FIFO of pending popup engagements.
 *
 * Dedupe is load-bearing: the server re-delivers every pending engagement on
 * EACH identify session, and one login can identify several times (connect +
 * enrichment re-identify). The seen-set spans the queue's lifetime and is
 * cleared only at a user boundary (different ext user id / logout).
 */
public final class EngagementQueue: @unchecked Sendable {
    private var items: [EngagementPayload] = []
    private var seenUids = Set<String>()
    /** Registration order; the id is the handle `onChange` hands back (closures have no identity). */
    private var changeListeners: [(id: Int, fn: () -> Void)] = []
    private var nextListenerId = 0
    private let lock = NSLock()

    public init() {}

    /**
     * Dedupe gate, shared by every engagement-bearing push (cid 110 popups AND
     * cid 105 execute_deeplink). First sight of a uid marks it seen and returns
     * false; repeats return true. Blank uids are never deduped.
     */
    public func isDuplicate(_ uid: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        if uid.isEmpty { return false }
        if seenUids.contains(uid) { return true }
        seenUids.insert(uid)
        return false
    }

    public func offer(_ msg: EngagementPayload) {
        lock.lock()
        items.append(msg)
        lock.unlock()
        emit()
    }

    /** Remove and return the oldest pending engagement (nil when empty). */
    public func take() -> EngagementPayload? {
        lock.lock()
        let item = items.isEmpty ? nil : items.removeFirst()
        lock.unlock()
        if item != nil { emit() }
        return item
    }

    public var size: Int {
        lock.lock()
        defer { lock.unlock() }
        return items.count
    }

    /** User boundary: drop pending items AND the dedupe history. */
    public func clear() {
        lock.lock()
        let had = !items.isEmpty
        items.removeAll()
        seenUids.removeAll()
        lock.unlock()
        if had { emit() }
    }

    /** Subscribe to queue-size changes. Returns unsubscribe. */
    public func onChange(_ fn: @escaping () -> Void) -> () -> Void {
        lock.lock()
        nextListenerId += 1
        let id = nextListenerId
        changeListeners.append((id, fn))
        lock.unlock()
        return { [weak self] in
            guard let self = self else { return }
            self.lock.lock()
            self.changeListeners.removeAll { $0.id == id }
            self.lock.unlock()
        }
    }

    private func emit() {
        lock.lock()
        let subs = changeListeners.map { $0.fn }
        lock.unlock()
        // (Kotlin: runCatching — a broken listener must not break the queue;
        // Swift listeners are non-throwing.)
        for fn in subs { fn() }
    }
}

/**
 * Host hooks a `PopupBridgeSession` drives. All UI decisions stay in the app.
 * Only `injectJs` is required; the rest default to no-ops (the extension below).
 *
 * The session keeps its hooks strongly. If the hooks object also keeps the
 * session (a WKWebView coordinator usually does), drop one side when the
 * popup closes, or the pair is never freed.
 */
public protocol PopupSessionHooks {
    /** Run JS inside the hosting WebView (iOS: `webView.evaluateJavaScript`). */
    func injectJs(_ js: String)

    /** The wrapper rendered the engagement — safe to reveal the (transparent) WebView. */
    func onReadyToShow()

    /** The wrapper asks to close (its own close button, or after a CTA). */
    func onClose()

    /** Override deep-link handling (default: the SDK dp router). */
    func onDeepLink(_ dp: String) -> Bool
}

extension PopupSessionHooks {
    public func onReadyToShow() {}
    public func onClose() {}
    public func onDeepLink(_ dp: String) -> Bool { false }
}

/**
 * Parse one bridge message: the wrapper pages post a JSON string
 * (`JSON.stringify({bcid, …})`); `WKScriptMessage.body` hands it over as a
 * `String`, or as `[String: Any]` if a page posts an object.
 */
func bridgeMessage(_ body: Any) -> JSONObject? {
    if let text = body as? String {
        return (try? JSON.parse(text))?.object
    }
    if body is [String: Any] {
        return JSON(any: body).object
    }
    return nil
}

/**
 * One popup's wrapper-page conversation (wrapper-popup.html over postMessage):
 *
 *   page → bcid 1 PAGE_READY          → session injects {bcid:3, ...payload}
 *   page → bcid 5 READY_TO_BE_SHOWN   → hooks.onReadyToShow (fade the WebView in)
 *   page → bcid 2 CLOSE_ME            → hooks.onClose
 *   page → bcid 4 EXECUTE_DEEP_LINK   → hooks.onClose, then dp router (CTA tap)
 *   page → bcid 6 SEND_TO_SOCKET      → forwarded verbatim (impression/click, cid 103/104)
 *
 * Feed every WebView postMessage into `handleMessage`; it returns whether the
 * message belonged to the bridge protocol.
 */
public final class PopupBridgeSession {
    private let payload: EngagementPayload
    private let hooks: PopupSessionHooks
    private let sendRaw: (JSONObject) -> Void
    private let runDp: (String) -> Bool

    public init(
        payload: EngagementPayload,
        hooks: PopupSessionHooks,
        sendRaw: @escaping (JSONObject) -> Void,
        runDp: @escaping (String) -> Bool
    ) {
        self.payload = payload
        self.hooks = hooks
        self.sendRaw = sendRaw
        self.runDp = runDp
    }

    @discardableResult
    public func handleMessage(_ data: String) -> Bool {
        handleMessage(body: data)
    }

    /** `WKScriptMessage.body` as is: a `String` or a `[String: Any]`. */
    @discardableResult
    public func handleMessage(body: Any) -> Bool {
        guard let msg = bridgeMessage(body) else { return false }
        switch msg["bcid"]?.int {
        case NativeBcid.PAGE_READY:
            inject()
            return true
        case NativeBcid.READY_TO_BE_SHOWN:
            hooks.onReadyToShow()
            return true
        case NativeBcid.CLOSE_ME:
            hooks.onClose()
            return true
        case NativeBcid.EXECUTE_DEEP_LINK:
            // CTA taps close the popup first, then route — a dp that opens a
            // screen/widget must not land underneath a still-visible popup.
            hooks.onClose()
            let dp = msg["dp"]?.string ?? ""
            if !dp.isEmpty && !hooks.onDeepLink(dp) { _ = runDp(dp) }
            return true
        case NativeBcid.SEND_TO_SOCKET:
            var socketMsg = msg
            socketMsg.removeValue(forKey: "bcid")
            sendRaw(socketMsg) // socket not up — reporting is best-effort
            return true
        default:
            return false
        }
    }

    /** Hand the wrapper its engagement: {bcid:3, ...payload} over a MessageEvent. */
    private func inject() {
        var data: JSONObject = ["bcid": JSON(NativeBcid.SHOW_ENGAGEMENT)]
        for (k, v) in payload { data[k] = v }
        // Double encode: the page's bridge expects a JSON STRING in event.data,
        // and that string has to be embedded as a JS string literal.
        let asJsString = JSON.string(JSON.object(data).jsonString()).jsonString()
        hooks.injectJs("window.dispatchEvent(new MessageEvent('message',{data:\(asJsString)}));true;")
    }
}
