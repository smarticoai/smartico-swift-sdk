// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetClanListResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    public var clans: [Clan]?
    /// The clan ID the current user belongs to; null if clanless
    public var user_clan_id: Int64?
    /// Cooldown until date string (e.g. "29/03/2026 10:00:00"); null if no cooldown
    public var cooldown_until: String?
    /// Epoch ms when the current user joined their clan; null if clanless
    public var join_date: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        clans: [Clan]? = nil,
        user_clan_id: Int64? = nil,
        cooldown_until: String? = nil,
        join_date: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.clans = clans
        self.user_clan_id = user_clan_id
        self.cooldown_until = cooldown_until
        self.join_date = join_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.clans = try c.lenientList(Clan.self, "clans")
        self.user_clan_id = try c.lenientInt64("user_clan_id")
        self.cooldown_until = try c.lenientString("cooldown_until")
        self.join_date = try c.lenientInt64("join_date")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
