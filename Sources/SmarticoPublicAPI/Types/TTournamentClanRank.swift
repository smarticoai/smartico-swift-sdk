// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TTournamentClanRank — generated from the anonymous object literal the public API
/// declares inline; the fields are exactly the ones declared there.
public struct TTournamentClanRank: Codable, Hashable, Sendable {
    public var clan_id: Int64?
    public var public_meta: JSON?
    public var position: Int64?
    public var total_score: Double?
    public var contributing_members: Double?

    public init(
        clan_id: Int64? = nil,
        public_meta: JSON? = nil,
        position: Int64? = nil,
        total_score: Double? = nil,
        contributing_members: Double? = nil
    ) {
        self.clan_id = clan_id
        self.public_meta = public_meta
        self.position = position
        self.total_score = total_score
        self.contributing_members = contributing_members
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.clan_id = try c.lenientInt64("clan_id")
        self.public_meta = try c.lenientJSON("public_meta")
        self.position = try c.lenientInt64("position")
        self.total_score = try c.lenientDouble("total_score")
        self.contributing_members = try c.lenientDouble("contributing_members")
    }
}
