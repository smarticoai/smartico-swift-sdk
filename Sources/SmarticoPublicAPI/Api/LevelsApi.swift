import Foundation

extension SmarticoApi {
    /**
     * The label's level ladder (VIP tiers). The user's own position comes from the
     * public properties: `ach_level_current_id` + `ach_points_ever`.
     *
     * Returned in server order (sort client-side if you need
     * the ladder order), with `ordinal_position` filled in: 1-based rank by
     * `required_points` ASC.
     */
    public func getLevels() async throws -> [TLevel] {
        try await call(
            cid: ClassId.GET_LEVEL_MAP_REQUEST,
            expectCid: ClassId.GET_LEVEL_MAP_RESPONSE,
            GetLevelMapResponse.self
        ).toTLevels()
    }
}

extension GetLevelMapResponse {
    /**
     * Wire shape → public shape: the server nests display fields under
     * `level_public_meta`, and `ordinal_position` is computed client-side.
     */
    func toTLevels() -> [TLevel] {
        guard let raw = levels else { return [] }
        let mapped = raw.map { l in
            TLevel(
                id: l.level_id,
                name: l.level_public_meta?.name,
                description: l.level_public_meta?.description,
                image: l.level_public_meta?.image_url,
                required_points: l.required_points,
                visibility_points: l.level_public_meta?.visibility_points,
                required_level_counter_1: l.required_level_counter_1,
                required_level_counter_2: l.required_level_counter_2,
                custom_data: jsonOrText(l.level_public_meta?.custom_data)
            )
        }
        // ordinal_position = 1-based rank by required_points ASC (ties keep input order)
        let ranked = mapped.enumerated().sorted { a, b in
            let pa = a.element.required_points ?? 0, pb = b.element.required_points ?? 0
            return pa != pb ? pa < pb : a.offset < b.offset
        }
        var ordinalById: [Int64?: Int64] = [:]
        for (i, lvl) in ranked.enumerated() { ordinalById[lvl.element.id] = Int64(i + 1) }
        return mapped.map { lvl in
            var out = lvl
            out.ordinal_position = ordinalById[lvl.id]
            return out
        }
    }
}
