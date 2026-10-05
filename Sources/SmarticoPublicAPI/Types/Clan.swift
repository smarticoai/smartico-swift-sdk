// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct Clan: Codable, Hashable, Sendable {
    public var clan_id: Int64?
    public var public_meta: ClanPublicMeta?
    public var member_count: Int64?
    public var capacity_limit: Double?
    /// ShopPurchaseType: 0=Points, 1=Gems, 2=Diamonds, 3=Free
    public var entry_fee_currency_type_id: Int64?
    public var entry_fee_amount: Double?
    /// F1 rank ASC, 1=best
    public var rating_position: Int64?
    public var rating_score: Double?

    public init(
        clan_id: Int64? = nil,
        public_meta: ClanPublicMeta? = nil,
        member_count: Int64? = nil,
        capacity_limit: Double? = nil,
        entry_fee_currency_type_id: Int64? = nil,
        entry_fee_amount: Double? = nil,
        rating_position: Int64? = nil,
        rating_score: Double? = nil
    ) {
        self.clan_id = clan_id
        self.public_meta = public_meta
        self.member_count = member_count
        self.capacity_limit = capacity_limit
        self.entry_fee_currency_type_id = entry_fee_currency_type_id
        self.entry_fee_amount = entry_fee_amount
        self.rating_position = rating_position
        self.rating_score = rating_score
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.clan_id = try c.lenientInt64("clan_id")
        self.public_meta = try c.lenientObject(ClanPublicMeta.self, "public_meta")
        self.member_count = try c.lenientInt64("member_count")
        self.capacity_limit = try c.lenientDouble("capacity_limit")
        self.entry_fee_currency_type_id = try c.lenientInt64("entry_fee_currency_type_id")
        self.entry_fee_amount = try c.lenientDouble("entry_fee_amount")
        self.rating_position = try c.lenientInt64("rating_position")
        self.rating_score = try c.lenientDouble("rating_score")
    }
}
