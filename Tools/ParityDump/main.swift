import CryptoKit
import Foundation
import SmarticoPublicAPI

/**
 * Captures, for every domain, BOTH the raw server response and what our Swift
 * transform made of it. `codegen/parity.ts` then feeds the same raw payload to
 * the reference implementation the types are generated from and diffs the two
 * outputs field by field — the real answer to "do all the fields match?".
 *
 * This is an executable target of its own, not a product (see Package.swift):
 * it talks to a live server and must never end up in what consumers link,
 * which is the `SmarticoPublicAPI` library alone. `swift build` still compiles
 * it, so it cannot rot unnoticed. It may use CryptoKit for the identify hash
 * because it is not the library.
 *
 * Output: `<domain>.raw.json` (the server reply), `<domain>.swift.json` (what this
 * SDK's transform made of it) and `meta.json`, read by `codegen/parity.ts`.
 *
 * Run (from the repository root, credentials in the environment):
 *       swift run ParityDump --check     prints which credentials were picked up, no connection
 *       swift run ParityDump             the live capture
 *       cd codegen && npm run parity
 */

private let TIMEOUT_MS = 20_000

/**
 * `build/parity` of this package, wherever `swift run` is invoked from — the
 * Gradle task passes the absolute `build/parity` of the project; the Swift
 * equivalent is this file's own location, two directories below the root.
 */
private func defaultOutDir() -> URL {
    URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent() // Tools/ParityDump
        .deletingLastPathComponent() // Tools
        .deletingLastPathComponent() // package root
        .appendingPathComponent("build/parity")
}

/** Print to stderr and exit non-zero. */
private func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data((message + "\n").utf8))
    exit(1)
}

/**
 * A required setting, with a message that says exactly what to set.
 *
 * Environment only:
 * Gradle, and SwiftPM has no counterpart to that file.
 */
private func env(_ name: String) -> String {
    if let v = ProcessInfo.processInfo.environment[name], !v.trimmingCharacters(in: .whitespaces).isEmpty {
        return v
    }
    fail(
        "\(name) is not set.\n\n" +
            "The parity capture runs against a live label. Set these in the environment\n" +
            "(there is no local.properties on the Swift side):\n" +
            "  SMARTICO_LABEL_KEY   the label key (its last character selects the environment)\n" +
            "  SMARTICO_BRAND_KEY   the brand key\n" +
            "  SMARTICO_EXT_USER    the external user id to identify as\n" +
            "  SMARTICO_SALT        optional; the label's identify secret (default \"null\", which demo labels use)\n\n" +
            "Then `swift run ParityDump --check` prints what was picked up, without connecting.\n"
    )
}

/**
 * The identify hash: md5("<user>:<salt>:<ts>") + ":" + ts.
 *
 * On a real label the secret never leaves the operator's backend and the host
 * app fetches the hash from there — computing it here only works because a
 * capture runs against a label whose secret we hold.
 */
private func identifyHash(_ user: String, _ salt: String) -> String {
    let ts = Int64(Date().timeIntervalSince1970) * 1000 + 24 * 3600 * 1000
    let digest = Insecure.MD5.hash(data: Data("\(user):\(salt):\(ts)".lowercased().utf8))
    let md5 = digest.map { String(format: "%02x", $0) }.joined()
    return "\(md5):\(ts)"
}

/**
 * Give up on the whole capture if `body` hangs.
 * A watchdog rather than a task-group race, because the identify wait is a
 * plain continuation that cannot be cancelled — a timed-out capture is
 * useless anyway, so the process just ends.
 */
private func withTimeout<T>(_ ms: Int, _ what: String, _ body: () async throws -> T) async rethrows -> T {
    let watchdog = Task {
        try await Task.sleep(nanoseconds: UInt64(ms) * 1_000_000)
        fail("timed out after \(ms) ms: \(what)")
    }
    defer { watchdog.cancel() }
    return try await body()
}

/** Completed once by the `identify` listener. */
private final class Deferred<T>: @unchecked Sendable {
    private let lock = NSLock()
    private var value: T?
    private var waiters: [CheckedContinuation<T, Never>] = []

    func complete(_ v: T) {
        lock.lock()
        if value != nil { lock.unlock(); return }
        value = v
        let w = waiters
        waiters = []
        lock.unlock()
        for c in w { c.resume(returning: v) }
    }

    func await() async -> T {
        await withCheckedContinuation { c in
            lock.lock()
            if let v = value {
                lock.unlock()
                c.resume(returning: v)
            } else {
                waiters.append(c)
                lock.unlock()
            }
        }
    }
}

/** Pretty, sorted, `/` unescaped — a stable file that reads well in a diff. */
private let encoder: JSONEncoder = {
    let e = JSONEncoder()
    e.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    return e
}()

private func run(_ args: [String]) async throws {
    let labelKey = env("SMARTICO_LABEL_KEY")
    let brandKey = env("SMARTICO_BRAND_KEY")
    let extUser = env("SMARTICO_EXT_USER")
    let salt = ProcessInfo.processInfo.environment["SMARTICO_SALT"].flatMap { $0.trimmingCharacters(in: .whitespaces).isEmpty ? nil : $0 } ?? "null"

    let outDir = args.first { !$0.hasPrefix("--") }.map { URL(fileURLWithPath: $0) } ?? defaultOutDir()

    // Confirm which settings were picked up without opening a socket — a
    // capture is expensive to get wrong.
    if args.contains("--check") {
        func mask(_ v: String) -> String { v.count <= 10 ? v : String(v.prefix(8)) + "…(\(v.count) chars)" }
        print("label key   \(mask(labelKey))")
        print("brand key   \(mask(brandKey))")
        print("ext user    \(extUser)")
        print("salt        " + (salt == "null" ? "\"null\" (demo default)" : "set (\(salt.count) chars)"))
        print("endpoint    \(Env.wsUrl(labelKey))")
        print("avatar host \(Env.avatarUrl(labelKey))")
        print("output dir  \(outDir.path)")
        print("\nSettings resolved. Run `swift run ParityDump` to capture.")
        exit(0)
    }

    try FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)

    func write(_ name: String, _ text: String) throws {
        try Data(text.utf8).write(to: outDir.appendingPathComponent(name))
    }

    func write<T: Encodable>(_ name: String, encoding value: T) throws {
        try encoder.encode(value).write(to: outDir.appendingPathComponent(name))
    }

    // The listener runs on the main queue, which the async top level keeps
    // draining while it is suspended.
    let identified = Deferred<JSONObject>()
    Smartico.on("identify") { identified.complete($0) }
    Smartico.initialize(
        labelKey: labelKey,
        options: SmarticoOptions(brandKey: brandKey, getUser: { SmarticoUser(extUserId: extUser, hash: identifyHash(extUser, salt)) })
    )
    _ = await withTimeout(TIMEOUT_MS, "identify") { await identified.await() }

    // The avatar transforms need the environment's image host to expand
    // avatar_id into a URL. Recording it with the capture keeps the JS side
    // from having to guess which environment the dump came from.
    try write("meta.json", encoding: [
        "label_key": labelKey,
        "avatar_domain": Env.avatarUrl(labelKey),
    ])

    /**
     * One list-shaped domain: the raw reply of the cid the typed getter uses,
     * then the getter itself. Two requests, not one decoded twice — the
     * transforms are internal to the library; this tool sees only its public
     * surface, like any consumer.
     */
    func capture<E: Encodable>(
        _ domain: String,
        _ reqCid: Int,
        _ respCid: Int,
        payload: JSONObject = [:],
        _ fetch: () async throws -> [E]
    ) async throws {
        let raw = try await withTimeout(TIMEOUT_MS, "\(domain) raw") { try await Smartico.raw.request(cid: reqCid, expectCid: respCid, payload: payload) }
        let mine = try await withTimeout(TIMEOUT_MS, "\(domain) typed") { try await fetch() }
        try write("\(domain).raw.json", JSON.object(raw).jsonString())
        try write("\(domain).swift.json", encoding: mine)
        print("captured \(domain) (\(mine.count) item(s))")
    }

    try await capture("levels", ClassId.GET_LEVEL_MAP_REQUEST, ClassId.GET_LEVEL_MAP_RESPONSE) { try await Smartico.api.getLevels() }
    try await capture("missions", ClassId.GET_ACHIEVEMENT_MAP_REQUEST, ClassId.GET_ACHIEVEMENT_MAP_RESPONSE) { try await Smartico.api.getMissions() }
    try await capture("badges", ClassId.GET_ACHIEVEMENT_MAP_REQUEST, ClassId.GET_ACHIEVEMENT_MAP_RESPONSE) { try await Smartico.api.getBadges() }
    try await capture("tournaments", ClassId.GET_TOURNAMENT_LOBBY_REQUEST, ClassId.GET_TOURNAMENT_LOBBY_RESPONSE) { try await Smartico.api.getTournamentsList() }
    try await capture("minigames", ClassId.SAW_GET_SPINS_REQUEST, ClassId.SAW_GET_SPINS_RESPONSE) { try await Smartico.api.getMiniGames() }
    try await capture("raffles", ClassId.RAF_GET_RAFFLES_REQUEST, ClassId.RAF_GET_RAFFLES_RESPONSE) { try await Smartico.api.getRaffles() }
    try await capture("store", ClassId.GET_SHOP_ITEMS_REQUEST, ClassId.GET_SHOP_ITEMS_RESPONSE) { try await Smartico.api.getStoreItems() }
    // The raw request carries the page the getter's defaults ask for (first 20,
    // not starred-only), so both halves describe the same set of messages.
    try await capture(
        "inbox", ClassId.GET_INBOX_MESSAGES_REQUEST, ClassId.GET_INBOX_MESSAGES_RESPONSE,
        payload: ["limit": 20, "offset": 0, "starred_only": false]
    ) { try await Smartico.api.getInboxMessages() }
    try await capture("avatars", ClassId.GET_AVATARS_LIST_REQUEST, ClassId.GET_AVATARS_LIST_RESPONSE) { try await Smartico.api.getAvatarsList() }
    try await capture("prompts", ClassId.GET_AVATAR_PROMPTS_REQUEST, ClassId.GET_AVATAR_PROMPTS_RESPONSE) { try await Smartico.api.getAvatarPrompts() }
    try await capture("customized", ClassId.GET_AVATARS_CUSTOMIZED_REQUEST, ClassId.GET_AVATARS_CUSTOMIZED_RESPONSE) { try await Smartico.api.getAvatarsCustomized() }
    try await capture("bonuses", ClassId.GET_BONUSES_REQUEST, ClassId.GET_BONUSES_RESPONSE) { try await Smartico.api.getBonuses() }

    // Clans answer with an object, not a list.
    let clansRaw = try await withTimeout(TIMEOUT_MS, "clans raw") { try await Smartico.raw.request(cid: ClassId.GET_CLAN_LIST_REQUEST, expectCid: ClassId.GET_CLAN_LIST_RESPONSE) }
    let clansMine = try await withTimeout(TIMEOUT_MS, "clans typed") { try await Smartico.api.getClans() }
    try write("clans.raw.json", JSON.object(clansRaw).jsonString())
    try write("clans.swift.json", encoding: clansMine)
    print("captured clans (\(clansMine.clans?.count ?? 0) clan(s))")

    // Leaderboard takes request params, so it can't use the plain capture().
    let lbRaw = try await withTimeout(TIMEOUT_MS, "leaderboard raw") {
        try await Smartico.raw.request(
            cid: ClassId.GET_LEADERS_BOARD_REQUEST,
            expectCid: ClassId.GET_LEADERS_BOARD_RESPONSE,
            payload: [
                "period_type_id": 1,
                "snapshot_offset": 0,
                "include_users": true,
            ]
        )
    }
    let lbMine = try await withTimeout(TIMEOUT_MS, "leaderboard typed") { try await Smartico.api.getLeaderBoard(periodType: LeaderBoardPeriodType.DAILY) }
    try write("leaderboard.raw.json", JSON.object(lbRaw).jsonString())
    if let lbMine = lbMine {
        try write("leaderboard.swift.json", encoding: lbMine)
        print("captured leaderboard (\(lbMine.users?.count ?? 0) user(s))")
    } else {
        try write("leaderboard.swift.json", "null")
        print("captured leaderboard (no board)")
    }

    let files = (try? FileManager.default.contentsOfDirectory(atPath: outDir.path))?.count ?? 0
    print("\nwrote \(files) files to \(outDir.path)")
    Smartico.logout()
}

do {
    try await run(Array(CommandLine.arguments.dropFirst()))
} catch {
    fail("parity capture failed: \(error)")
}
// The socket's URLSession keeps the process alive otherwise `).
exit(0)
