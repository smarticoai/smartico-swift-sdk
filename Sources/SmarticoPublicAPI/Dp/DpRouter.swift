import Foundation

/**
 * Deep-link ("dp:") support — the protocol layer. Operators author deep links
 * in campaign CTAs (popup/inbox buttons, mission CTAs, pushes); this SDK owns
 * the grammar, the action catalog and the dispatch pipeline, while the host app
 * injects UI bindings (screen navigation, URL opening, widget hosting).
 *
 * Pipeline:
 *   parse-time: http(s)://, "/", "dp:/" strings are GO links;
 *   1) built-in catalog (no-ops, host actions, native screens, widget screens);
 *   2) registered custom handlers;
 *   3) warn + drop — no fallback.
 */
public struct DeepLink: Hashable, Sendable {
    public var action: String
    public var params: [String: String]
    public var raw: String

    public init(action: String, params: [String: String], raw: String) {
        self.action = action
        self.params = params
        self.raw = raw
    }
}

/** Grammar: `dp:<action>[&key[=value]]*`; a bare `&flag` means "true"; URI-decoded. */
public func parseDp(_ raw: String?) -> DeepLink {
    let s = (raw ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    if s.range(of: "^(https?://|/)", options: [.regularExpression, .caseInsensitive]) != nil
        || s.lowercased().hasPrefix("dp:/") {
        let url = s.lowercased().hasPrefix("dp:/") ? String(s.dropFirst(3)) : s
        return DeepLink(action: "go", params: ["url": url], raw: s)
    }
    let body = s.lowercased().hasPrefix("dp:") ? String(s.dropFirst(3)) : s
    var parts = body.components(separatedBy: "&")
    let action = (parts.isEmpty ? "" : parts.removeFirst())
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
    var params: [String: String] = [:]
    for p in parts {
        if p.isEmpty { continue }
        let i = p.firstIndex(of: "=")
        let k = decode(i == nil ? p : String(p[..<i!])).lowercased()
        let v = i == nil ? "true" : decode(String(p[p.index(after: i!)...]))
        if !k.isEmpty { params[k] = v }
    }
    return DeepLink(action: action, params: params, raw: s)
}

/** `URLDecoder.decode(s, "UTF-8")`: `+` is a space, `%XX` is decoded; malformed input stays as is. */
private func decode(_ s: String) -> String {
    s.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? s
}

/**
 * Logical app screens the built-in catalog can request from the host app.
 * The raw values are the Kotlin constant names.
 */
public enum DpScreen: String, CaseIterable, Sendable {
    case missions = "MISSIONS"
    case tournaments = "TOURNAMENTS"
    case jackpots = "JACKPOTS"
    case raffles = "RAFFLES"
    case levels = "LEVELS"
    case profile = "PROFILE"
    case inbox = "INBOX"
    case leaderboard = "LEADERBOARD"
}

/** UI bindings supplied by the host app. Every method has a default (the extension below). */
public protocol DpBindings {
    /** dp:go / URL deep links. */
    func openUrl(_ url: String, target: String?)

    /** Widget-only experiences (gf_saw, gf_store, …) — host in a WebView.
     * Return false to decline: the dp then falls through to custom handlers. */
    func openWidget(_ dp: DeepLink) -> Bool

    /** Natively rendered screens. Return false to decline (dp is then dropped). */
    func openScreen(_ screen: DpScreen, _ dp: DeepLink) -> Bool

    /** dp:ask_push_permissions — a campaign asks the native shell to show the
     * OS push-permission prompt (and re-register the token afterwards). */
    func requestPushPermissions()
}

extension DpBindings {
    public func openUrl(_ url: String, target: String?) {}
    public func openWidget(_ dp: DeepLink) -> Bool { false }
    public func openScreen(_ screen: DpScreen, _ dp: DeepLink) -> Bool { false }
    public func requestPushPermissions() {}
}

/** Custom handler for operator-specific actions; return true if handled. */
public typealias DpHandler = (DeepLink) -> Bool

// Catalog of known actions.
private let NATIVE_SCREENS: [String: DpScreen] = [
    "gf_missions": .missions,
    "gf_tournaments": .tournaments,
    "gf_jackpots": .jackpots,
    "gf_raffle": .raffles,
    "gf_levels": .levels,
    "gf_badges": .profile,
    "gf_change_avatar": .profile,
    "gf_change_nickname": .profile,
    "inbox": .inbox,
    "gf_activity": .inbox,
    "gf_board": .leaderboard,
    "gf_board_previous": .leaderboard,
    "gf_board_rules": .leaderboard,
]

private let WIDGET_ACTIONS: Set<String> = [
    "gf", "gf_saw", "gf_section", "gf_store", "gf_matchx", "gf_quiz", "gf_bonuses", "gf_settings", "gf_clans",
]

// Engagement-tracking no-ops (Ok/Cancel/Close) + widget-close service dps.
private let NOOP_ACTIONS: Set<String> = ["ok", "cancel", "close", "close_me", "gf_close"]

/** Is this dp action a widget-only experience (rendered by the gamification widget)? */
public func isWidgetAction(_ action: String) -> Bool {
    WIDGET_ACTIONS.contains(action.lowercased())
}

public final class DpRouter {
    /** When false (default), unhandled deep links are dropped silently. */
    public static var debug: Bool = false

    /** Sends the `dp:action&action=x` tracking event over the socket. */
    private let sendClientAction: (String) -> Void

    private let lock = NSLock()
    private var bindings: DpBindings?
    /** Registration order; the id is the handle `register` hands back (closures have no identity). */
    private var handlers: [(id: Int, fn: DpHandler)] = []
    private var nextHandlerId = 0

    public init(sendClientAction: @escaping (String) -> Void) {
        self.sendClientAction = sendClientAction
    }

    public func configure(_ bindings: DpBindings) {
        lock.lock()
        defer { lock.unlock() }
        self.bindings = bindings
    }

    /** Register a custom handler for operator-specific actions. Returns unregister. */
    public func register(_ fn: @escaping DpHandler) -> () -> Void {
        lock.lock()
        defer { lock.unlock() }
        nextHandlerId += 1
        let id = nextHandlerId
        handlers.append((id, fn))
        return { [weak self] in
            guard let self = self else { return }
            self.lock.lock()
            defer { self.lock.unlock() }
            self.handlers.removeAll { $0.id == id }
        }
    }

    /** Execute a deep link. Returns false if nothing handled it. */
    @discardableResult
    public func run(_ raw: String?) -> Bool {
        guard let raw = raw, !raw.isEmpty else { return false }
        let dp = parseDp(raw)
        lock.lock()
        let b = bindings
        let hs = handlers.map { $0.fn }
        lock.unlock()

        if NOOP_ACTIONS.contains(dp.action) { return true }

        if dp.action == "ask_push_permissions" {
            b?.requestPushPermissions()
            return true // handled either way — apps without the binding keep the legacy no-op
        }

        if dp.action == "go" {
            if let url = dp.params["url"], let b = b {
                b.openUrl(url, target: dp.params["target"])
                return true
            }
            return false
        }

        if dp.action == "action" {
            if let action = dp.params["action"] {
                sendClientAction(action) // not connected yet — tracking only
            }
            return true
        }

        if let screen = NATIVE_SCREENS[dp.action] {
            if let b = b, b.openScreen(screen, dp) { return true }
        }

        if WIDGET_ACTIONS.contains(dp.action), let b = b {
            if b.openWidget(dp) { return true }
            // declined → fall through to custom handlers
        }

        // (Kotlin wraps each handler in runCatching — a broken handler must not
        // kill routing; Swift handlers are non-throwing.)
        for h in hs {
            if h(dp) { return true }
        }

        if DpRouter.debug { smarticoLog("[Smartico] no handler for deep link, dropped: \(dp.raw)") }
        return false
    }
}
