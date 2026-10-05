import Foundation

extension SmarticoApi {
    /**
     * Operator bonuses awarded to the user (free spins, deposit matches, …).
     *
     * `is_redeemable` says the user may claim it now; the two meta maps carry the
     * operator's own bonus payload (template config + per-award values), which the
     * host app renders as it sees fit.
     */
    public func getBonuses() async throws -> [TBonus] {
        try await call(
            cid: ClassId.GET_BONUSES_REQUEST,
            expectCid: ClassId.GET_BONUSES_RESPONSE,
            GetBonusesResponse.self
        ).bonuses.orEmpty().toTBonuses()
    }

    /** Claim a redeemable bonus. Check `success` / `err_code` — refusals are business-level. */
    public func claimBonus(bonus_id: Int64) async throws -> TClaimBonusResult {
        let r = try await call(
            cid: ClassId.CLAIM_BONUS_REQUEST,
            expectCid: ClassId.CLAIM_BONUS_RESPONSE,
            ClaimBonusResponse.self,
            payload: ["bonusId": JSON(bonus_id)]
        )
        return TClaimBonusResult(err_code: r.errCode, err_message: r.errMsg, success: r.success)
    }
}

extension Array where Element == Bonus {
    func toTBonuses() -> [TBonus] {
        filter { ($0.id ?? 0) >= 1 }.map { r in
            TBonus(
                bonus_id: r.id,
                is_redeemable: r.redeemable,
                create_date: r.createDate,
                redeem_date: r.redeemDate,
                label_bonus_template_id: r.labelBonusTemplateId.map { Lenient.truncate($0) },
                bonus_status_id: r.bonusStatusId,
                label_bonus_template_meta_map: r.labelBonusTemplateMetaMap,
                bonus_meta_map: r.bonusMetaMap
            )
        }
    }
}
