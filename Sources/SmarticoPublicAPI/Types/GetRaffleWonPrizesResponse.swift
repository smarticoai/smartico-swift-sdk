// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetRaffleWonPrizesResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    /// The user the won prizes belong to; `null` when `won_prizes` is empty.
    public var user: RaffleWonPrizeUser?
    /// Page of won prizes for the requested raffle, newest-first.
    public var won_prizes: [RaffleWonPrize]?
    /// Total number of won prizes for this user/raffle across all draws (for pagination).
    public var total: Double?
    /// Zero-based offset of this page (echoes the resolved request).
    public var offset: Double?
    /// Page size (echoes the resolved request).
    public var limit: Double?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        user: RaffleWonPrizeUser? = nil,
        won_prizes: [RaffleWonPrize]? = nil,
        total: Double? = nil,
        offset: Double? = nil,
        limit: Double? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.user = user
        self.won_prizes = won_prizes
        self.total = total
        self.offset = offset
        self.limit = limit
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.user = try c.lenientObject(RaffleWonPrizeUser.self, "user")
        self.won_prizes = try c.lenientList(RaffleWonPrize.self, "won_prizes")
        self.total = try c.lenientDouble("total")
        self.offset = try c.lenientDouble("offset")
        self.limit = try c.lenientDouble("limit")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
