// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TClan describes one clan item from the clans list.
public struct TClan: Codable, Hashable, Sendable {
    /// Clan ID
    public var clan_id: Int64?
    /// Translated clan metadata
    public var public_meta: JSON?
    /// Current number of members in clan
    public var member_count: Int64?
    /// Max number of members allowed in clan
    public var capacity_limit: Double?
    /// Currency type for `entry_fee_amount`. `0` = points, `1` = gems,
    /// `2` = diamonds, `3` = free (no fee).
    public var entry_fee_currency_type_id: Int64?
    /// Entry fee amount in the currency indicated by `entry_fee_currency_type_id`.
    /// `0` (or `entry_fee_currency_type_id === 3`) means the clan is free to join.
    public var entry_fee_amount: Double?
    /// Global rank among all active clans in the label, by `rating_score` DESC.
    /// `1` = highest-rated. May skip positions when some clans are hidden by
    /// per-user visibility (e.g. user sees positions 1, 3, 7).
    public var rating_position: Int64?
    /// Clan rating score (higher is better).
    public var rating_score: Double?

    public init(
        clan_id: Int64? = nil,
        public_meta: JSON? = nil,
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
        self.public_meta = try c.lenientJSON("public_meta")
        self.member_count = try c.lenientInt64("member_count")
        self.capacity_limit = try c.lenientDouble("capacity_limit")
        self.entry_fee_currency_type_id = try c.lenientInt64("entry_fee_currency_type_id")
        self.entry_fee_amount = try c.lenientDouble("entry_fee_amount")
        self.rating_position = try c.lenientInt64("rating_position")
        self.rating_score = try c.lenientDouble("rating_score")
    }
}
