// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanPrizeStructureEntry: Codable, Hashable, Sendable {
    public var clan_place: Double?
    /// 1 = Fixed, 2 = Dynamic
    public var prize_type_id: Int64?
    public var prize_pool_amount: Double?
    public var prize_pool_currency_code: String?
    public var activity_type_id: Int64?
    public var details_json: [String: JSON]?
    public var public_meta: ClanPrizePublicMeta?
    public var player_tiers: [ClanPrizeTier]?

    public init(
        clan_place: Double? = nil,
        prize_type_id: Int64? = nil,
        prize_pool_amount: Double? = nil,
        prize_pool_currency_code: String? = nil,
        activity_type_id: Int64? = nil,
        details_json: [String: JSON]? = nil,
        public_meta: ClanPrizePublicMeta? = nil,
        player_tiers: [ClanPrizeTier]? = nil
    ) {
        self.clan_place = clan_place
        self.prize_type_id = prize_type_id
        self.prize_pool_amount = prize_pool_amount
        self.prize_pool_currency_code = prize_pool_currency_code
        self.activity_type_id = activity_type_id
        self.details_json = details_json
        self.public_meta = public_meta
        self.player_tiers = player_tiers
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.clan_place = try c.lenientDouble("clan_place")
        self.prize_type_id = try c.lenientInt64("prize_type_id")
        self.prize_pool_amount = try c.lenientDouble("prize_pool_amount")
        self.prize_pool_currency_code = try c.lenientString("prize_pool_currency_code")
        self.activity_type_id = try c.lenientInt64("activity_type_id")
        self.details_json = try c.lenientDict(JSON.self, "details_json")
        self.public_meta = try c.lenientObject(ClanPrizePublicMeta.self, "public_meta")
        self.player_tiers = try c.lenientList(ClanPrizeTier.self, "player_tiers")
    }
}
