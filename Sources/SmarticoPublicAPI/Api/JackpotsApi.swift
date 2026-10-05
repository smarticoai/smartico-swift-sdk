import Foundation

extension SmarticoApi {
    /**
     * Jackpots. Unlike other domains the server response needs no reshaping —
     * `JackpotDetails` is already the public shape.
     *
     * Designed for ~1 Hz polling: the pot value (`pot.current_pot_amount_user_currency`)
     * is what makes the counter tick, so a UI can call this every second. Don't add
     * a client-side cache on top — it would flatten the counting-up effect.
     */
    public func jackpotGet(related_game_id: String? = nil, jp_template_id: Int64? = nil) async throws -> [JackpotDetails] {
        var payload: JSONObject = [:]
        if let related_game_id = related_game_id { payload["related_game_id"] = JSON(related_game_id) }
        if let jp_template_id = jp_template_id { payload["jp_template_id"] = JSON(jp_template_id) }
        return try await call(
            cid: ClassId.JP_GET_JACKPOTS_REQUEST,
            expectCid: ClassId.JP_GET_JACKPOTS_RESPONSE,
            GetJackpotsResponse.self,
            payload: payload
        ).items ?? []
    }

    /** Join a jackpot (opt-in). */
    public func jackpotOptIn(jp_template_id: Int64) async throws -> JackpotsOptinResponse {
        try await call(
            cid: ClassId.JP_OPTIN_REQUEST,
            expectCid: ClassId.JP_OPTIN_RESPONSE,
            JackpotsOptinResponse.self,
            payload: ["jp_template_id": JSON(jp_template_id)]
        )
    }

    /** Leave a jackpot (opt-out). */
    public func jackpotOptOut(jp_template_id: Int64) async throws -> JackpotsOptoutResponse {
        try await call(
            cid: ClassId.JP_OPTOUT_REQUEST,
            expectCid: ClassId.JP_OPTOUT_RESPONSE,
            JackpotsOptoutResponse.self,
            payload: ["jp_template_id": JSON(jp_template_id)]
        )
    }
}
