// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TClanTournamentPlayers describes the players of a specific clan in a clan-based tournament.
public struct TClanTournamentPlayers: Codable, Hashable, Sendable {
    /// Tournament instance ID
    public var tournament_instance_id: Int64?
    /// Top players of this clan ranked by score DESC
    public var players: JSON?

    public init(
        tournament_instance_id: Int64? = nil,
        players: JSON? = nil
    ) {
        self.tournament_instance_id = tournament_instance_id
        self.players = players
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.tournament_instance_id = try c.lenientInt64("tournament_instance_id")
        self.players = try c.lenientJSON("players")
    }
}
