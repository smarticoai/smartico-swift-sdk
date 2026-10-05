// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanLeaderboardEntry: Codable, Hashable, Sendable {
    public var clanId: Double?
    public var publicMeta: ClanPublicMeta?
    public var rank: Double?
    public var totalScore: Double?
    public var memberCount: Int64?

    public init(
        clanId: Double? = nil,
        publicMeta: ClanPublicMeta? = nil,
        rank: Double? = nil,
        totalScore: Double? = nil,
        memberCount: Int64? = nil
    ) {
        self.clanId = clanId
        self.publicMeta = publicMeta
        self.rank = rank
        self.totalScore = totalScore
        self.memberCount = memberCount
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.clanId = try c.lenientDouble("clanId")
        self.publicMeta = try c.lenientObject(ClanPublicMeta.self, "publicMeta")
        self.rank = try c.lenientDouble("rank")
        self.totalScore = try c.lenientDouble("totalScore")
        self.memberCount = try c.lenientInt64("memberCount")
    }
}
