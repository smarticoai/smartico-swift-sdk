// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TGetJackpotEligibleGamesResponse: Codable, Hashable, Sendable {
    public var eligible_games: [JackpotEligibleGame]?

    public init(
        eligible_games: [JackpotEligibleGame]? = nil
    ) {
        self.eligible_games = eligible_games
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.eligible_games = try c.lenientList(JackpotEligibleGame.self, "eligible_games")
    }
}
