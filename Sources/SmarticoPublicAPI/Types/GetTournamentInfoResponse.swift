// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetTournamentInfoResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    /// tournament info
    public var tournamentInfo: JSON?
    /// information about current user position
    public var userPosition: TournamentPlayer?
    /// prizes structure
    public var prizeStructure: JSON?
    /// Ranked list of clans in this tournament. Empty/null for non-clan tournaments.
    public var clanLeaderboard: [ClanLeaderboardEntry]?
    /// The clan ID the current user belongs to.
    /// null when the user has no clan or the tournament is not clan-based.
    /// Match against clanLeaderboard[i].clan_id to highlight the user's clan row.
    public var userClanId: Double?
    /// Per-clan prize structure. Empty/null for non-clan tournaments.
    public var clanPrizes: [ClanPrizeStructureEntry]?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        tournamentInfo: JSON? = nil,
        userPosition: TournamentPlayer? = nil,
        prizeStructure: JSON? = nil,
        clanLeaderboard: [ClanLeaderboardEntry]? = nil,
        userClanId: Double? = nil,
        clanPrizes: [ClanPrizeStructureEntry]? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.tournamentInfo = tournamentInfo
        self.userPosition = userPosition
        self.prizeStructure = prizeStructure
        self.clanLeaderboard = clanLeaderboard
        self.userClanId = userClanId
        self.clanPrizes = clanPrizes
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.tournamentInfo = try c.lenientJSON("tournamentInfo")
        self.userPosition = try c.lenientObject(TournamentPlayer.self, "userPosition")
        self.prizeStructure = try c.lenientJSON("prizeStructure")
        self.clanLeaderboard = try c.lenientList(ClanLeaderboardEntry.self, "clanLeaderboard")
        self.userClanId = try c.lenientDouble("userClanId")
        self.clanPrizes = try c.lenientList(ClanPrizeStructureEntry.self, "clanPrizes")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
