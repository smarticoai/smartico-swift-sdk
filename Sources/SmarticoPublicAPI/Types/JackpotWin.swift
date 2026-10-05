// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotWin: Codable, Hashable, Sendable {
    /// Won amount in the Jackpot currency
    public var winning_amount: Double?
    /// Date of winning in milliseconds
    public var win_date_ts: Int64?
    /// Name of the winner, masked by default. `null` when the jackpot template doesn't expose winners over API
    public var public_username: String?

    public init(
        winning_amount: Double? = nil,
        win_date_ts: Int64? = nil,
        public_username: String? = nil
    ) {
        self.winning_amount = winning_amount
        self.win_date_ts = win_date_ts
        self.public_username = public_username
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.winning_amount = try c.lenientDouble("winning_amount")
        self.win_date_ts = try c.lenientInt64("win_date_ts")
        self.public_username = try c.lenientString("public_username")
    }
}
