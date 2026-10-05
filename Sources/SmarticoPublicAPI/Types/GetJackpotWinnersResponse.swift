// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetJackpotWinnersResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    /// The list of jackpot winners
    public var winners: [JackpotWinnerHistory]?
    /// Whether there are more winners to fetch
    public var has_more: Bool?
    /// Win statistics of the jackpot template
    public var win_stats: JackpotWinStats?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        winners: [JackpotWinnerHistory]? = nil,
        has_more: Bool? = nil,
        win_stats: JackpotWinStats? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.winners = winners
        self.has_more = has_more
        self.win_stats = win_stats
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.winners = try c.lenientList(JackpotWinnerHistory.self, "winners")
        self.has_more = try c.lenientBool("has_more")
        self.win_stats = try c.lenientObject(JackpotWinStats.self, "win_stats")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
