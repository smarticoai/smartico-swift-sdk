import Foundation

/**
 * ClassIds for the connection lifecycle: the numbers the server uses to tell
 * one message type from another.
 */
public enum Cid {
    public static let PING = 1
    public static let PONG = 2
    public static let INIT = 3
    public static let INIT_RESPONSE = 4
    public static let IDENTIFY = 5
    public static let IDENTIFY_RESPONSE = 6
    public static let LOGIN = 7
    public static let LOGIN_RESPONSE = 11
    public static let LOGOUT = 8
    public static let LOGOUT_RESPONSE = 12
    public static let EVENT = 9
    public static let EVENT_RESPONSE = 10
    public static let SET_CUSTOM_USERNAME = 159
    public static let SET_CUSTOM_USERNAME_RESPONSE = 160
    public static let REGISTER_PUSH_TOKEN = 1003 // REGISTER_PUSH_NOTIFICATIONS_TOKEN_REQ
}

/** Platform codes for registerPushToken (the protocol's PushClientPlatform enum). */
public enum PushPlatform {
    public static let NATIVE_IOS = 6
    public static let NATIVE_ANDROID = 7
}

/**
 * Friendly names for the ClassIds the server pushes on its own. Subscribe by
 * name (`on("props_change")`)
 * or by raw cid (`on(108)`) — both fire.
 */
public let PUSH_EVENT_NAMES: [Int: String] = [
    108: "props_change",        // CLIENT_PUBLIC_PROPERTIES_CHANGED_EVENT (points/balance)
    110: "engagement",          // CLIENT_ENGAGEMENT_EVENT_NEW (popup / new inbox message)
    504: "reload_achievements", // RELOAD_ACHIEVEMENTS_EVENT
    706: "spins_count",         // SAW_SPINS_COUNT_PUSH
    707: "show_spin",           // SAW_SHOW_SPIN_PUSH
    708: "prize_drop_win",      // SAW_PRIZE_DROP_WIN_PUSH
    808: "jp_win",              // JP_WIN_PUSH
    105: "execute_deeplink",    // CLIENT_EXECUTE_DEEPLINK_EVENT
    107: "execute_js",          // CLIENT_EXECUTE_JS_EVENT
]

public let SDK_VERSION = "smartico-swift-0.0.1"

/** Send a proactive PING once the server has been silent this long. */
public let NO_MESSAGE_TIMER_MS = 29_000

/** API version string the integration guide documents for the papi reporting endpoint. */
let PAPI_REPORT_VERSION = "1.2.25"

/**
 * Environment routing, derived from the label key itself: a 38-char key ends
 * with "-<env digit>"; envs 1 and 2 map to the bare production hosts.
 */
public enum Env {
    public static func dnsSuffix(_ labelKey: String) -> String {
        let id = labelKey.count == 38 ? String(labelKey.suffix(1)) : ""
        return id == "1" || id == "2" ? "" : id
    }

    /** The WebSocket endpoint for this label's environment. */
    public static func wsUrl(_ labelKey: String) -> String {
        "wss://api\(dnsSuffix(labelKey)).smartico.ai/websocket/services"
    }

    /** The public HTTP endpoint (push analytics reporting, guide §5). */
    public static func publicUrl(_ labelKey: String) -> String {
        "https://papi\(dnsSuffix(labelKey)).smartico.ai/services/public"
    }

    /** CDN host serving avatar images for this environment. */
    public static func avatarUrl(_ labelKey: String) -> String {
        "https://img\(dnsSuffix(labelKey)).smr.vc"
    }

    /** The label key without the "-<env>" suffix (what INIT sends as label_key). */
    public static func cleanLabelKey(_ labelKey: String) -> String {
        labelKey.count > 36 ? String(labelKey.prefix(36)) : labelKey
    }
}

/**
 * Random v4 uuid (request correlation, session_id, device_id fallback).
 * Lowercase, the form `java.util.UUID.toString()` and the JS tracker produce.
 */
public func guid() -> String {
    UUID().uuidString.lowercased()
}

/** Wall-clock milliseconds (`System.currentTimeMillis()`), the `ts` of every frame. */
func nowMs() -> Int64 {
    Int64((Date().timeIntervalSince1970 * 1000).rounded(.down))
}

/**
 * One `[Smartico]` log line on stdout (Kotlin: `println`). Flushed right away:
 * a piped stdout (simctl --console, CI) would otherwise hold lines until exit.
 */
func smarticoLog(_ line: String) {
    print(line)
    fflush(stdout)
}

/**
 * `java.net.URLEncoder.encode(s, "UTF-8")`: form encoding — ASCII letters,
 * digits and `.-*_` stay, a space becomes `+`, every other UTF-8 byte is `%XX`.
 * Foundation's `addingPercentEncoding` has no exact equivalent (its
 * `alphanumerics` set includes non-ASCII letters), hence the byte loop.
 */
func formUrlEncode(_ s: String) -> String {
    var out = ""
    out.reserveCapacity(s.utf8.count)
    for b in s.utf8 {
        switch b {
        case UInt8(ascii: "a")...UInt8(ascii: "z"),
             UInt8(ascii: "A")...UInt8(ascii: "Z"),
             UInt8(ascii: "0")...UInt8(ascii: "9"),
             UInt8(ascii: "."), UInt8(ascii: "-"), UInt8(ascii: "*"), UInt8(ascii: "_"):
            out.unicodeScalars.append(Unicode.Scalar(b))
        case UInt8(ascii: " "):
            out += "+"
        default:
            out += "%"
            out += String(b >> 4, radix: 16, uppercase: true)
            out += String(b & 0x0F, radix: 16, uppercase: true)
        }
    }
    return out
}

/** The current user's identity + auth proof (hash issued by the operator backend). */
public struct SmarticoUser: Hashable, Sendable {
    public var extUserId: String
    public var hash: String

    public init(extUserId: String, hash: String) {
        self.extUserId = extUserId
        self.hash = hash
    }
}

/** Engagement refs a push notification carries in its data payload. */
public struct PushEngagementRef: Hashable, Sendable {
    public var engagementUid: String
    public var messageId: String?
    /** The push's deep link — reported with ENGAGEMENT_ACTION (and executed by the host). */
    public var action: String?

    public init(engagementUid: String, messageId: String? = nil, action: String? = nil) {
        self.engagementUid = engagementUid
        self.messageId = messageId
        self.action = action
    }
}

/**
 * Push lifecycle analytics (integration guide §5). HTTP, not socket: pushes
 * arrive when the app may be closed and no socket exists.
 */
public enum PushEngagementEventType: String, Sendable {
    case delivered = "engagement_delivered"
    case impression = "engagement_impression"
    case action = "engagement_action"
    case failed = "engagement_failed"

    /** The wire name (Kotlin's `wire` property). */
    public var wire: String { rawValue }
}

/**
 * Errors thrown by the SDK. `timeout` and `connectionClosed` are Kotlin's
 * `SmarticoTimeoutException` / `SmarticoClosedException`; `notInitialized` is
 * what the facade's throwing methods raise before `Smartico.initialize`;
 * `decoding` wraps a response that did not decode into its generated type.
 */
public enum SmarticoError: Error, CustomStringConvertible, LocalizedError {
    case timeout(cid: Int)
    case connectionClosed
    case notInitialized
    case http(Int)
    case decoding(Error)

    public var description: String {
        switch self {
        case .timeout(let cid): return "Smartico request timed out (cid \(cid))"
        case .connectionClosed: return "Smartico connection closed"
        case .notInitialized: return "Smartico.initialize must be called first"
        case .http(let code): return "Smartico HTTP error \(code)"
        case .decoding(let error): return "Smartico response decoding failed: \(error)"
        }
    }

    public var errorDescription: String? { description }
}

/** Options for `SmarticoConnection`. */
public struct SmarticoOptions: Sendable {
    public var brandKey: String?
    /**
     * Returns the current user's credentials, or nil if no user is logged in
     * yet. The SDK calls this ITSELF after INIT and on every reconnect, then
     * sends IDENTIFY automatically — no manual identify() call. Return a FRESH
     * hash each call (it expires); fetch it from the operator backend.
     */
    public var getUser: (@Sendable () async -> SmarticoUser?)?
    /** Stable per-install id. Auto-generated if omitted (persist it for stability). */
    public var deviceId: String?
    /** Override the WS endpoint. Defaults to Env.wsUrl(labelKey). */
    public var wsUrl: String?
    /** Optional `domain` query param. The server ignores it; kept for parity. */
    public var domain: String?
    /** Client version string sent as the `version` query param. */
    public var version: String?
    /** Auto-reconnect after the socket closes (default: true). */
    public var reconnect: Bool = true
    /** Fail a request if no response arrives within this long. */
    public var requestTimeoutMs: Int = 30_000
    /** Connection lifecycle logs. */
    public var debug: Bool = false
    /** With debug: also dump every non-ping socket frame (IN/OUT). Very chatty. */
    public var traceFrames: Bool = false

    public init(
        brandKey: String? = nil,
        getUser: (@Sendable () async -> SmarticoUser?)? = nil,
        deviceId: String? = nil,
        wsUrl: String? = nil,
        domain: String? = nil,
        version: String? = nil,
        reconnect: Bool = true,
        requestTimeoutMs: Int = 30_000,
        debug: Bool = false,
        traceFrames: Bool = false
    ) {
        self.brandKey = brandKey
        self.getUser = getUser
        self.deviceId = deviceId
        self.wsUrl = wsUrl
        self.domain = domain
        self.version = version
        self.reconnect = reconnect
        self.requestTimeoutMs = requestTimeoutMs
        self.debug = debug
        self.traceFrames = traceFrames
    }
}
