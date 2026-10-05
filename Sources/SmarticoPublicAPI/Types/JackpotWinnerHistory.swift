// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotWinnerHistory: Codable, Hashable, Sendable {
    /// Id of the jackpot pot
    public var jp_pot_id: Int64?
    /// Date of winning in milliseconds
    public var win_date_ts: Int64?
    /// Info about jackpot winner
    public var winner: JackPotWinner?

    public init(
        jp_pot_id: Int64? = nil,
        win_date_ts: Int64? = nil,
        winner: JackPotWinner? = nil
    ) {
        self.jp_pot_id = jp_pot_id
        self.win_date_ts = win_date_ts
        self.winner = winner
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.jp_pot_id = try c.lenientInt64("jp_pot_id")
        self.win_date_ts = try c.lenientInt64("win_date_ts")
        self.winner = try c.lenientObject(JackPotWinner.self, "winner")
    }
}
