import Foundation

/**
 * The user's own profile, level standing and segment membership.
 */
extension SmarticoApi {
    /**
     * Snapshot of the user's public properties (points, level, balances, language,
     * …), kept current by the props_change push — no round-trip. `avatar_url` is
     * expanded from the raw avatar id.
     */
    public func getUserProfile() async throws -> TUserProfile {
        let props = await conn.getPublicProps()
        var obj = JSONObject()
        for (k, v) in props { obj[k] = v }
        if let id = props["avatar_id"]?.string {
            obj["avatar_url"] = JSON(id.hasPrefix("http") ? id : trimTrailingSlashes(Env.avatarUrl(conn.label)) + "/avatar/" + id)
        }
        return try decodeWire(TUserProfile.self, obj)
    }

    /**
     * The user's current level with progress to the next one (0–100).
     *
     * Falls back to locating the level by `points_ever` when the server's
     * `ach_level_current_id` doesn't match any ladder entry.
     */
    public func getCurrentLevel() async throws -> TLevelCurrent? {
        let levels = try await getLevels().sorted { ($0.required_points ?? 0) < ($1.required_points ?? 0) }
        if levels.isEmpty { return nil }
        let props = await conn.getPublicProps()
        let currentId = props["ach_level_current_id"]?.int64
        let pointsEver = props["ach_points_ever"]?.int64 ?? 0

        var idx = levels.firstIndex { $0.id == currentId } ?? -1
        if idx == -1 {
            idx = levels.indices.first { i in
                let lvl = levels[i]
                let next = i + 1 < levels.count ? levels[i + 1] : nil
                return pointsEver >= (lvl.required_points ?? 0) && (next == nil || pointsEver < (next?.required_points ?? 0))
            } ?? -1
            if idx == -1 { idx = levels.count - 1 }
        }
        let current = levels[idx]
        let next = idx + 1 < levels.count ? levels[idx + 1] : nil
        let progress: Double
        if let next = next {
            let span = (next.required_points ?? 0) - (current.required_points ?? 0)
            progress = span <= 0 ? 100.0 : Double(pointsEver - (current.required_points ?? 0)) * 100.0 / Double(span)
        } else {
            progress = 100.0
        }
        return TLevelCurrent(
            id: current.id,
            name: current.name,
            description: current.description,
            image: current.image,
            required_points: current.required_points,
            visibility_points: current.visibility_points,
            required_level_counter_1: current.required_level_counter_1,
            required_level_counter_2: current.required_level_counter_2,
            // TLevelCurrent still declares custom_data as a string
            custom_data: current.custom_data.map { $0.string ?? $0.jsonString() },
            ordinal_position: current.ordinal_position,
            progress: min(max(progress, 0.0), 100.0)
        )
    }

    /** Sliding-window level counters, for labels that level on activity rather than points. */
    public func getUserLevelExtraCounters() async -> UserLevelExtraCountersT {
        let props = await conn.getPublicProps()
        return UserLevelExtraCountersT(
            level_counter_1: props["ach_level_counter_1"]?.int64,
            level_counter_2: props["ach_level_counter_2"]?.int64
        )
    }

    /** Mission/badge categories (the operator's grouping; shared by both). */
    public func getAchCategories() async throws -> [TAchCategory] {
        try await call(
            cid: ClassId.GET_ACH_CATEGORIES_REQUEST,
            expectCid: ClassId.GET_ACH_CATEGORIES_RESPONSE,
            GetAchCategoriesResponse.self
        ).categories.orEmpty().map { $0.toTAchCategory() }
    }

    /** Is the user in this segment? A server round-trip every call — no cache. */
    public func checkSegmentMatch(segment_id: Int64) async throws -> Bool {
        try await checkSegmentListMatch(segment_ids: [segment_id]).first?.is_matching == true
    }

    /** Check several segments in one round-trip. */
    public func checkSegmentListMatch(segment_ids: [Int64]) async throws -> [TSegmentCheckResult] {
        let r = try await conn.request(
            cid: ClassId.CHECK_SEGMENT_MATCH_REQUEST,
            expectCid: ClassId.CHECK_SEGMENT_MATCH_RESPONSE,
            // The request field is `segment_id` (an array of ids), as in
            // PROTOCOL.md and the JS SDK. The Kotlin SDK sends `segment_ids`,
            // which the server rejects (errCode 1 with a server-side NPE and
            // `segments: null`), so every id came back false there.
            payload: ["segment_id": .array(segment_ids.map { JSON($0) })]
        )
        // `segments` is an array of {segment_id, is_matching} on the wire; an
        // object keyed by id (the shape the Kotlin SDK reads) is accepted too.
        var matched: [Int64: Bool] = [:]
        if let rows = r["segments"]?.array {
            for row in rows {
                if let id = row["segment_id"]?.int64, let m = strictBool(row["is_matching"]) { matched[id] = m }
            }
        } else if let byId = r["segments"]?.object {
            for (key, value) in byId {
                if let id = Int64(key), let m = strictBool(value) { matched[id] = m }
            }
        }
        return segment_ids.map { id in
            TSegmentCheckResult(segment_id: id, is_matching: matched[id] ?? false)
        }
    }

    /** Operator translations for a language, as a flat key → text map. */
    public func getTranslations(lang_code: String) async throws -> TGetTranslations {
        let r = try await call(
            cid: ClassId.GET_TRANSLATIONS_REQUEST,
            expectCid: ClassId.GET_TRANSLATIONS_RESPONSE,
            GetTranslationsResponse.self,
            payload: [
                "lang_code": JSON(lang_code),
                "areas": [],
            ]
        )
        return TGetTranslations(translations: r.translations)
    }

    /** Missions and tournaments tied to a specific casino game (`ext_game_id`). */
    public func getRelatedItemsForGame(related_game_id: String) async throws -> GetRelatedAchTourResponse {
        try await call(
            cid: ClassId.GET_RELATED_ACH_N_TOURNAMENTS_REQUEST,
            expectCid: ClassId.GET_RELATED_ACH_N_TOURNAMENTS_RESPONSE,
            GetRelatedAchTourResponse.self,
            payload: ["related_game_id": JSON(related_game_id)]
        )
    }
}

extension AchCategory {
    func toTAchCategory() -> TAchCategory { TAchCategory(id: id, name: publicMeta?.name, order: publicMeta?.order) }
}

/** Kotlin's `content.toBooleanStrictOrNull()`: exactly `true` / `false` (a bool or its text). */
private func strictBool(_ j: JSON?) -> Bool? {
    switch j?.string {
    case "true": return true
    case "false": return false
    default: return nil
    }
}

/** Kotlin's `trimEnd('/')`. */
private func trimTrailingSlashes(_ s: String) -> String {
    var out = Substring(s)
    while out.hasSuffix("/") { out = out.dropLast() }
    return String(out)
}

/**
 * `apiJson.decodeFromJsonElement(T.serializer(), raw)`: an already-parsed JSON
 * value into a generated type, whose own `init(from:)` is lenient. A failure
 * surfaces as `SmarticoError.decoding`, the same as from `call`.
 */
func decodeWire<T: Decodable>(_ type: T.Type, _ raw: JSON) throws -> T {
    do {
        return try apiDecoder.decode(T.self, from: raw.data(sortedKeys: false))
    } catch {
        throw SmarticoError.decoding(error)
    }
}

/** `decodeWire` for an object (the usual case: a response or a CDN document). */
func decodeWire<T: Decodable>(_ type: T.Type, _ raw: JSONObject) throws -> T {
    try decodeWire(type, JSON.object(raw))
}
