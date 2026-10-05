// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AffectsProgress: Codable, Hashable, Sendable {
    public var affects_level: Bool?
    public var affects_leaderboard: Bool?
    public var affects_current_balance: Bool?
    public var rewardPoints: Int64?

    public init(
        affects_level: Bool? = nil,
        affects_leaderboard: Bool? = nil,
        affects_current_balance: Bool? = nil,
        rewardPoints: Int64? = nil
    ) {
        self.affects_level = affects_level
        self.affects_leaderboard = affects_leaderboard
        self.affects_current_balance = affects_current_balance
        self.rewardPoints = rewardPoints
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.affects_level = try c.lenientBool("affects_level")
        self.affects_leaderboard = try c.lenientBool("affects_leaderboard")
        self.affects_current_balance = try c.lenientBool("affects_current_balance")
        self.rewardPoints = try c.lenientInt64("rewardPoints")
    }
}
