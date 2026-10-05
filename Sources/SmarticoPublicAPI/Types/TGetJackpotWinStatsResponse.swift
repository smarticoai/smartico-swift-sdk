// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TGetJackpotWinStatsResponse: Codable, Hashable, Sendable {
    /// The list of jackpot winners
    public var winners: [JackpotWinnerHistory]?
    /// Win statistics of the jackpot template
    public var win_stats: JackpotWinStats?

    public init(
        winners: [JackpotWinnerHistory]? = nil,
        win_stats: JackpotWinStats? = nil
    ) {
        self.winners = winners
        self.win_stats = win_stats
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.winners = try c.lenientList(JackpotWinnerHistory.self, "winners")
        self.win_stats = try c.lenientObject(JackpotWinStats.self, "win_stats")
    }
}
