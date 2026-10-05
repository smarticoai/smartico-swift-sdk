// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TBonus describes one bonus awarded to the user.
/// Returned by `Smartico.api.getBonuses()`.
public struct TBonus: Codable, Hashable, Sendable {
    /// Stable ID of the bonus.
    public var bonus_id: Int64?
    /// `true` when the bonus is in a player-claim-required state.
    /// Gate the Claim button on this; see `claimBonus` TSDoc.
    public var is_redeemable: Bool?
    /// Bonus creation timestamp as ISO 8601 UTC string
    /// ("YYYY-MM-DDTHH:MM:SS", no timezone suffix).
    public var create_date: String?
    /// Bonus redemption timestamp as ISO 8601 UTC string. Absent until
    /// the bonus reaches `BonusStatus.REDEEMED`.
    public var redeem_date: String?
    /// ID of the bonus template used to issue this bonus.
    public var label_bonus_template_id: Int64?
    /// Lifecycle status; see {@link BonusStatus}.
    public var bonus_status_id: Int64?
    /// Template-level display metadata (operator-configured, identical
    /// across all bonuses from the same template).
    public var label_bonus_template_meta_map: BonusTemplateMetaMap?
    /// Instance-level display metadata (per-issuance; carries the
    /// dynamic amount computed at award time).
    public var bonus_meta_map: BonusMetaMap?

    public init(
        bonus_id: Int64? = nil,
        is_redeemable: Bool? = nil,
        create_date: String? = nil,
        redeem_date: String? = nil,
        label_bonus_template_id: Int64? = nil,
        bonus_status_id: Int64? = nil,
        label_bonus_template_meta_map: BonusTemplateMetaMap? = nil,
        bonus_meta_map: BonusMetaMap? = nil
    ) {
        self.bonus_id = bonus_id
        self.is_redeemable = is_redeemable
        self.create_date = create_date
        self.redeem_date = redeem_date
        self.label_bonus_template_id = label_bonus_template_id
        self.bonus_status_id = bonus_status_id
        self.label_bonus_template_meta_map = label_bonus_template_meta_map
        self.bonus_meta_map = bonus_meta_map
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.bonus_id = try c.lenientInt64("bonus_id")
        self.is_redeemable = try c.lenientBool("is_redeemable")
        self.create_date = try c.lenientString("create_date")
        self.redeem_date = try c.lenientString("redeem_date")
        self.label_bonus_template_id = try c.lenientInt64("label_bonus_template_id")
        self.bonus_status_id = try c.lenientInt64("bonus_status_id")
        self.label_bonus_template_meta_map = try c.lenientObject(BonusTemplateMetaMap.self, "label_bonus_template_meta_map")
        self.bonus_meta_map = try c.lenientObject(BonusMetaMap.self, "bonus_meta_map")
    }
}
