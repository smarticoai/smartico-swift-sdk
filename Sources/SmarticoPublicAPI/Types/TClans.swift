// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TClans describes the clans payload returned by the API.
public struct TClans: Codable, Hashable, Sendable {
    /// List of active clans available to the user
    public var clans: [TClan]?
    /// The clan ID the current user belongs to; null if clanless
    public var user_clan_id: Int64?
    /// Switch-cooldown expiry as ISO 8601 UTC string ("YYYY-MM-DDTHH:MM:SS"
    /// with no timezone suffix; interpret as UTC). `null` when no cooldown.
    /// User-level: while set, the user cannot join any clan.
    public var cooldown_until: String?
    /// Epoch ms when the current user joined their clan; null if clanless
    public var join_date: Int64?

    public init(
        clans: [TClan]? = nil,
        user_clan_id: Int64? = nil,
        cooldown_until: String? = nil,
        join_date: Int64? = nil
    ) {
        self.clans = clans
        self.user_clan_id = user_clan_id
        self.cooldown_until = cooldown_until
        self.join_date = join_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.clans = try c.lenientList(TClan.self, "clans")
        self.user_clan_id = try c.lenientInt64("user_clan_id")
        self.cooldown_until = try c.lenientString("cooldown_until")
        self.join_date = try c.lenientInt64("join_date")
    }
}
