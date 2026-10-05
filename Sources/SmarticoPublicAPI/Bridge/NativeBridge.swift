import Foundation

/**
 * Native-bridge protocol constants + wrapper URL builder — the WebView side of
 * Smartico's official iOS/Android integration (wrapper-gf.html /
 * wrapper-popup.html). Kept in the SDK so host apps don't duplicate protocol
 * knowledge.
 */
public enum NativeBcid {
    public static let PAGE_READY = 1
    public static let CLOSE_ME = 2
    public static let SHOW_ENGAGEMENT = 3
    public static let EXECUTE_DEEP_LINK = 4
    public static let READY_TO_BE_SHOWN = 5
    public static let SEND_TO_SOCKET = 6
    public static let SEND_PUBLIC_PROPS = 7
    public static let SEND_GAME_OPENING = 8
}

/** Required WebView user agent (integration guide: device_type WRAPPER). */
public let SMTO_WRAPPER_UA = "SMTO-WRAPPER"

public let WRAPPER_GF_URL = "https://libs.smartico.ai/wrapper-gf.html"
public let WRAPPER_POPUP_URL = "https://libs.smartico.ai/wrapper-popup.html"

/**
 * Build a wrapper page URL. Prefers `base` (the server-built `native_app_gf_url`
 * from IDENTIFY_RESPONSE) when given, appending dp/hash only as needed;
 * otherwise composes from label/brand/user params.
 *
 * `forceMobile` (default true): the widget picks its mobile/desktop layout from
 * a user-agent regex, and the required SMTO-WRAPPER UA matches no mobile token —
 * without this flag it renders the DESKTOP layout squeezed into a phone.
 */
public func buildWrapperUrl(
    labelKey: String,
    brandKey: String,
    extUserId: String,
    base: String? = nil,
    wrapper: String = WRAPPER_GF_URL,
    hash: String? = nil,
    dp: String? = nil,
    forceMobile: Bool = true
) -> String {
    func enc(_ s: String) -> String { formUrlEncode(s) }
    if let base = base {
        var u = base
        if let dp = dp { u += (u.contains("?") ? "&" : "?") + "dp=" + enc(dp) }
        if let hash = hash, base.range(of: "[?&]hash=", options: .regularExpression) == nil { u += "&hash=" + enc(hash) }
        if forceMobile && !u.contains("force_mobile") { u += (u.contains("?") ? "&" : "?") + "force_mobile=true" }
        return u
    }
    var q = [
        "label_key=" + enc(labelKey),
        "brand_key=" + enc(brandKey),
        "user_ext_id=" + enc(extUserId),
    ]
    if let hash = hash { q.append("hash=" + enc(hash)) }
    if let dp = dp { q.append("dp=" + enc(dp)) }
    if forceMobile { q.append("force_mobile=true") }
    return "\(wrapper)?\(q.joined(separator: "&"))"
}

/**
 * Host hooks a `WidgetBridgeSession` drives. All UI decisions stay in the app.
 * `onNavigateInWidget` is required; `onReady`/`onClose` default to no-ops.
 * The session keeps its hooks strongly (see `PopupSessionHooks`).
 */
public protocol WidgetSessionHooks {
    /** The widget rendered (READY_TO_BE_SHOWN) — hide your loader. */
    func onReady()

    /** The widget asks to close (CLOSE_ME, or a gf_close deep link) — pop the host screen. */
    func onClose()

    /**
     * A widget-family deep link emitted INSIDE the widget (respin offers,
     * section jumps, …) — reload the SAME WebView with this dp in its URL.
     * Routing it globally instead would yank the user out of the mini-game.
     */
    func onNavigateInWidget(_ dpRaw: String)
}

extension WidgetSessionHooks {
    public func onReady() {}
    public func onClose() {}
}

/**
 * One hosted widget's native-bridge conversation (wrapper-gf.html over
 * postMessage). Unlike a popup there is no inject step — the widget gets
 * identity and its deep link from the URL (see `buildWrapperUrl`):
 *
 *   page → READY_TO_BE_SHOWN → hooks.onReady (hide the loader)
 *   page → CLOSE_ME          → hooks.onClose
 *   page → EXECUTE_DEEP_LINK → gf_close: onClose;
 *                              widget-family: onNavigateInWidget (stay inside);
 *                              anything else: onClose, then the dp router
 *   page → SEND_TO_SOCKET    → forwarded verbatim (engagement analytics)
 *
 * Feed every WebView postMessage into `handleMessage`; it returns whether the
 * message belonged to the bridge protocol.
 */
public final class WidgetBridgeSession {
    private let hooks: WidgetSessionHooks
    private let sendRaw: (JSONObject) -> Void
    private let runDp: (String) -> Bool

    public init(
        hooks: WidgetSessionHooks,
        sendRaw: @escaping (JSONObject) -> Void,
        runDp: @escaping (String) -> Bool
    ) {
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
        case NativeBcid.READY_TO_BE_SHOWN:
            hooks.onReady()
            return true
        case NativeBcid.CLOSE_ME:
            hooks.onClose()
            return true
        case NativeBcid.EXECUTE_DEEP_LINK:
            let raw = msg["dp"]?.string ?? ""
            if !raw.isEmpty {
                let link = parseDp(raw)
                if link.action == "gf_close" {
                    hooks.onClose()
                } else if isWidgetAction(link.action) {
                    hooks.onNavigateInWidget(raw)
                } else {
                    hooks.onClose()
                    _ = runDp(raw)
                }
            }
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
}
