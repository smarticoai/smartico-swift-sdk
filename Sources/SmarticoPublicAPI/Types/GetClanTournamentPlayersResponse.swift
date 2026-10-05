// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetClanTournamentPlayersResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    public var tournament_instance_id: Int64?
    public var players: [ClanTournamentPlayerRaw]?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        tournament_instance_id: Int64? = nil,
        players: [ClanTournamentPlayerRaw]? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.tournament_instance_id = tournament_instance_id
        self.players = players
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.tournament_instance_id = try c.lenientInt64("tournament_instance_id")
        self.players = try c.lenientList(ClanTournamentPlayerRaw.self, "players")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
