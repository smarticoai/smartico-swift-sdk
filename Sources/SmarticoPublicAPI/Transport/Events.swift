import Foundation

/**
 * Event keys for `on` — a friendly name ("props_change", "engagement",
 * "identify", …) or a raw ClassId. Kotlin takes `Any` (String or Int); Swift
 * spells the same two shapes as cases, and the literal conformances keep the
 * call sites identical: `Smartico.on("identify") { … }`, `Smartico.on(110) { … }`.
 */
public enum SmarticoEvent: Hashable, Sendable, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    case name(String)
    case cid(Int)

    public init(stringLiteral value: String) {
        self = .name(value)
    }

    public init(integerLiteral value: Int) {
        self = .cid(value)
    }
}

/**
 * Handle returned by `on`; pass it to `off` to unsubscribe. Kotlin removes a
 * callback by identity (`off(event, cb)`); Swift closures have none, so the
 * registration itself is the handle. Tokens are unique process-wide, which lets
 * the facade attach the SAME token to every connection it creates.
 */
public struct SubscriptionToken: Hashable, Sendable {
    let id: UInt64

    private static let counter = LockedBox<UInt64>(0)

    static func next() -> SubscriptionToken {
        SubscriptionToken(id: counter.withLock { n -> UInt64 in
            n += 1
            return n
        })
    }
}

/**
 * Listener registry, shared by `SmarticoConnection` (the per-socket one) and
 * the `Smartico` facade (the persistent one it re-attaches on every init).
 * Insertion-ordered, so callbacks for one event run in subscription order.
 *
 * Lock-protected rather than actor-isolated: `on`/`off` must return
 * synchronously (the token), and delivery happens on the main queue.
 */
final class ListenerRegistry: @unchecked Sendable {
    typealias Callback = (JSONObject) -> Void

    private struct Entry {
        let event: SmarticoEvent
        let token: SubscriptionToken
        let cb: Callback
    }

    private var entries: [Entry] = []
    private let lock = NSLock()

    /** Register `cb` under a fresh token. */
    @discardableResult
    func add(_ event: SmarticoEvent, _ cb: @escaping Callback) -> SubscriptionToken {
        add(event, token: SubscriptionToken.next(), cb)
    }

    /** Register `cb` under an existing token (facade re-attach). Idempotent per token. */
    @discardableResult
    func add(_ event: SmarticoEvent, token: SubscriptionToken, _ cb: @escaping Callback) -> SubscriptionToken {
        lock.lock()
        defer { lock.unlock() }
        if !entries.contains(where: { $0.token == token }) {
            entries.append(Entry(event: event, token: token, cb: cb))
        }
        return token
    }

    func remove(_ token: SubscriptionToken) {
        lock.lock()
        defer { lock.unlock() }
        entries.removeAll { $0.token == token }
    }

    /** Snapshot of the callbacks for `event`, in subscription order. */
    func callbacks(for event: SmarticoEvent) -> [Callback] {
        lock.lock()
        defer { lock.unlock() }
        return entries.filter { $0.event == event }.map { $0.cb }
    }

    /** Every registration, in subscription order (what the facade re-attaches). */
    func all() -> [(event: SmarticoEvent, token: SubscriptionToken, cb: Callback)] {
        lock.lock()
        defer { lock.unlock() }
        return entries.map { ($0.event, $0.token, $0.cb) }
    }

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return entries.count
    }
}

/**
 * A value behind an `NSLock` — the `@Volatile` / `synchronized(lock)` of the
 * Kotlin code (Foundation only; `Mutex` and `OSAllocatedUnfairLock` need newer
 * OS floors than iOS 15 / macOS 12).
 */
final class LockedBox<Value>: @unchecked Sendable {
    private var value: Value
    private let lock = NSLock()

    init(_ value: Value) {
        self.value = value
    }

    func get() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    func set(_ newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }

    @discardableResult
    func withLock<R>(_ body: (inout Value) throws -> R) rethrows -> R {
        lock.lock()
        defer { lock.unlock() }
        return try body(&value)
    }
}
