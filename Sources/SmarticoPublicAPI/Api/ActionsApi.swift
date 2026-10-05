import Foundation

/**
 * The write side of the API: everything that changes state — playing a
 * mini-game, joining a tournament, claiming a reward, buying an item.
 *
 * All of these return the server's error code; a non-zero `errCode` is a
 * business refusal (no attempts left, not enough points, registration closed),
 * not a transport failure, so check it rather than relying on exceptions.
 */
extension SmarticoApi {
    // ---- mini-games -------------------------------------------------------------

    /**
     * Play one round. Returns the prize the user won.
     *
     * With `acknowledge` left on (the default) the win is confirmed for you; pass
     * `false` when the UI wants to reveal the prize first and call
     * `miniGameWinAcknowledgeRequest` with the returned `request_id` afterwards —
     * until acknowledged the win stays pending on the server.
     *
     * A `minigame_attempt` client event is reported automatically (operators build
     * funnels on it).
     */
    public func playMiniGame(
        template_id: Int64,
        acknowledge: Bool = true
    ) async throws -> TMiniGamePlayResult {
        let requestId = guid()
        let resp = try await call(
            cid: ClassId.SAW_DO_SPIN_REQUEST,
            expectCid: ClassId.SAW_DO_SPIN_RESPONSE,
            SAWDoSpinResponse.self,
            payload: [
                "saw_template_id": JSON(template_id),
                "request_id": JSON(requestId),
            ]
        )
        await reportAttempt(template_id, spinStatus(resp.errCode), nil)
        if acknowledge { _ = try await miniGameWinAcknowledgeRequest(requestId: requestId) }
        return TMiniGamePlayResult(
            err_code: resp.errCode,
            err_message: resp.errMsg,
            prize_id: resp.saw_prize_id,
            // the server echoes no request_id — hand back ours so a deferred
            // acknowledge is still possible
            request_id: requestId
        )
    }

    /** Play several rounds in one call (lootboxes / multi-spin UIs); wins are acknowledged for you. */
    public func playMiniGameBatch(template_id: Int64, spin_count: Int) async throws -> [TMiniGamePlayBatchResult] {
        let resp = try await call(
            cid: ClassId.SAW_DO_SPIN_BATCH_REQUEST,
            expectCid: ClassId.SAW_DO_SPIN_BATCH_RESPONSE,
            SAWDoSpinBatchResponse.self,
            payload: [
                "spins": .array((0..<max(0, spin_count)).map { _ in
                    [
                        "request_id": JSON(guid()),
                        "saw_template_id": JSON(template_id),
                    ]
                }),
            ]
        )
        let anyOk = resp.results.orEmpty().contains { $0.errCode == 0 }
        await reportAttempt(template_id, anyOk ? "OK" : "BATCH FAIL", nil)
        for id in resp.results.orEmpty().compactMap({ $0.request_id }) {
            _ = try? await miniGameWinAcknowledgeRequest(requestId: id)
        }
        return resp.results.orEmpty().map {
            TMiniGamePlayBatchResult(
                saw_prize_id: $0.saw_prize_id,
                errCode: $0.errCode,
                errMessage: $0.errMsg,
                jackpot_amount: $0.jackpot_amount,
                first_spin_in_period: $0.first_spin_in_period
            )
        }
    }

    /**
     * Confirm the user saw their prize. `lose` marks the "no prize" acknowledgement.
     * Pass the `request_id` from `playMiniGame`.
     */
    public func miniGameWinAcknowledgeRequest(requestId: String, lose: Bool? = nil) async throws -> SAWDoAknowledgeResponse {
        var payload: JSONObject = ["request_id": JSON(requestId)]
        if let lose = lose { payload["lose"] = JSON(lose) }
        return try await call(
            cid: ClassId.SAW_AKNOWLEDGE_REQUEST,
            expectCid: ClassId.SAW_AKNOWLEDGE_RESPONSE,
            SAWDoAknowledgeResponse.self,
            payload: payload
        )
    }

    private func reportAttempt(_ templateId: Int64, _ status: String, _ roundId: Int64?) async {
        var payload: JSONObject = [
            "saw_template_id": JSON(templateId),
            "status": JSON(status),
        ]
        if let roundId = roundId { payload["round_id"] = JSON(roundId) }
        _ = try? await conn.event("minigame_attempt", payload: payload)
    }

    // ---- missions ---------------------------------------------------------------

    /** Join a mission that requires opting in (`is_requires_optin`). */
    public func requestMissionOptIn(missionId: Int64) async throws -> TMissionOptInResult {
        try requireArg(missionId != 0, "Missing mission id")
        let r = try await conn.request(
            cid: ClassId.MISSION_OPTIN_REQUEST,
            expectCid: ClassId.MISSION_OPTIN_RESPONSE,
            payload: ["achievementId": JSON(missionId)]
        )
        return TMissionOptInResult(err_code: r.errCodeOrNull(), err_message: r.errMsgOrNull())
    }

    /**
     * Claim a completed mission's prize. `achCompletedId` comes from the mission's
     * `ach_completed_id` — a mission can be completed several times (recurring),
     * and the server needs to know which completion is being claimed.
     */
    public func requestMissionClaimReward(missionId: Int64, achCompletedId: Int64) async throws -> TMissionClaimRewardResult {
        try requireArg(missionId != 0, "Missing mission id")
        let r = try await conn.request(
            cid: ClassId.ACHIEVEMENT_CLAIM_PRIZE_REQUEST,
            expectCid: ClassId.ACHIEVEMENT_CLAIM_PRIZE_RESPONSE,
            payload: [
                "ach_id": JSON(missionId),
                "ach_completed_id": JSON(achCompletedId),
            ]
        )
        return TMissionClaimRewardResult(err_code: r.errCodeOrNull(), err_message: r.errMsgOrNull())
    }

    // ---- tournaments ------------------------------------------------------------

    /**
     * Register for a tournament. Business refusals arrive as `err_code`:
     * 30002 not enough balance · 30003 registration closed · 30004 already
     * registered · 30005 segment mismatch · 30008 tournament full.
     */
    public func registerInTournament(tournamentInstanceId: Int64) async throws -> TTournamentRegistrationResult {
        try requireArg(tournamentInstanceId != 0, "Missing tournament instance id")
        let r = try await call(
            cid: ClassId.TOURNAMENT_REGISTER_REQUEST,
            expectCid: ClassId.TOURNAMENT_REGISTER_RESPONSE,
            TournamentRegisterResponse.self,
            payload: ["tournamentInstanceId": JSON(tournamentInstanceId)]
        )
        return TTournamentRegistrationResult(err_code: r.errCode, err_message: r.errMsg)
    }

    // ---- store ------------------------------------------------------------------

    /** Buy a store item with the user's gamification currency. */
    public func buyStoreItem(item_id: Int64) async throws -> TBuyStoreItemResult {
        try requireArg(item_id != 0, "Missing item id")
        let r = try await call(
            cid: ClassId.BUY_SHOP_ITEM_REQUEST,
            expectCid: ClassId.BUY_SHOP_ITEM_RESPONSE,
            BuyStoreItemResponse.self,
            payload: ["itemId": JSON(item_id)]
        )
        return TBuyStoreItemResult(err_code: r.errCode, err_message: r.errMsg)
    }

    // ---- raffles ----------------------------------------------------------------

    /** Opt into a raffle draw (only when the draw has `requires_optin`). */
    public func requestRaffleOptin(raffle_id: Int64, draw_id: Int64, raffle_run_id: Int64) async throws -> TRaffleOptinResponse {
        let r = try await call(
            cid: ClassId.RAF_OPTIN_REQUEST,
            expectCid: ClassId.RAF_OPTIN_RESPONSE,
            RaffleOptinResponse.self,
            payload: [
                "raffle_id": JSON(raffle_id),
                "draw_id": JSON(draw_id),
                "raffle_run_id": JSON(raffle_run_id),
            ]
        )
        return TRaffleOptinResponse(err_code: r.errCode, err_message: r.errMsg)
    }

    /** Claim a raffle prize the user won (`won_id` = the prize's `raf_won_id`). */
    public func claimRafflePrize(won_id: Int64) async throws -> TransformedRaffleClaimPrizeResponse {
        try requireArg(won_id != 0, "won_id is required")
        let r = try await call(
            cid: ClassId.RAF_CLAIM_PRIZE_REQUEST,
            expectCid: ClassId.RAF_CLAIM_PRIZE_RESPONSE,
            RaffleClaimPrizeResponse.self,
            payload: ["won_id": JSON(won_id)]
        )
        // this one names its fields errorCode/errorMessage, unlike its siblings
        return TransformedRaffleClaimPrizeResponse(errorCode: r.errCode.map { Double($0) }, errorMessage: r.errMsg)
    }
}

/** Human-readable spin outcome, reported with the attempt event. */
func spinStatus(_ errCode: Int64?) -> String {
    switch errCode {
    case SAWSpinErrorCode.SAW_OK: return "OK"
    case SAWSpinErrorCode.SAW_NO_SPINS: return "NO SPINS AVAILABLE"
    case SAWSpinErrorCode.SAW_PRIZE_POOL_EMPTY: return "PRIZE POOL IS EMPTY"
    case SAWSpinErrorCode.SAW_NOT_ENOUGH_POINTS: return "NOT ENOUGH POINTS"
    case SAWSpinErrorCode.SAW_FAILED_MAX_SPINS_REACHED: return "MAX SPIN ATTEMPTS REACHED"
    case SAWSpinErrorCode.SAW_TEMPLATE_NOT_ACTIVE: return "MINIGAME IS NOT IN ACTIVE PERIOD"
    case SAWSpinErrorCode.SAW_NOT_IN_SEGMENT: return "USER IS NOT IN SEGMENT"
    case SAWSpinErrorCode.SAW_NO_BALANCE_GEMS: return "NOT ENOUGH GEMS"
    case SAWSpinErrorCode.SAW_NO_BALANCE_DIAMONDS: return "NOT ENOUGH DIAMONDS"
    default: return "OTHER"
    }
}

private extension Dictionary where Key == String, Value == JSON {
    func errCodeOrNull() -> Int64? {
        self["errCode"]?.string.flatMap { Double($0) }.map { Lenient.truncate($0) }
    }

    func errMsgOrNull() -> String? {
        self["errMsg"]?.string
    }
}

/**
 * What Kotlin's `require(…)` / `error(…)` throw (IllegalArgumentException /
 * IllegalStateException): a bad argument or a missing entity, with a message.
 * Thrown rather than trapped, so the host can catch it as on the JVM;
 * `SmarticoError` has no case for it.
 */
struct SmarticoApiPreconditionError: Error, CustomStringConvertible, LocalizedError {
    let message: String
    var description: String { message }
    var errorDescription: String? { message }
}

/** Kotlin's `require(condition) { message }`. */
func requireArg(_ condition: Bool, _ message: @autoclosure () -> String) throws {
    if !condition { throw SmarticoApiPreconditionError(message: message()) }
}
