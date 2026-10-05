// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotWinStats: Codable, Hashable, Sendable {
    /// Total number of issued wins of the jackpot template. Wins waiting for manual approval are not counted
    public var total_wins: Double?
    /// The biggest win of the jackpot template, `null` when there are no wins yet
    public var highest_win: JackpotWin?
    /// The most recent win of the jackpot template, `null` when there are no wins yet
    public var last_win: JackpotWin?

    public init(
        total_wins: Double? = nil,
        highest_win: JackpotWin? = nil,
        last_win: JackpotWin? = nil
    ) {
        self.total_wins = total_wins
        self.highest_win = highest_win
        self.last_win = last_win
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.total_wins = try c.lenientDouble("total_wins")
        self.highest_win = try c.lenientObject(JackpotWin.self, "highest_win")
        self.last_win = try c.lenientObject(JackpotWin.self, "last_win")
    }
}
