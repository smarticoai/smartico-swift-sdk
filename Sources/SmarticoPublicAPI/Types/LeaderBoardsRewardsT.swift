// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// LeaderBoardsRewardsT describes one place's prize on a leaderboard.
/// Leaderboard prizes are always gamification points (never gems / diamonds / items).
public struct LeaderBoardsRewardsT: Codable, Hashable, Sendable {
    /// Place number (1-based).
    public var place: Double?
    /// Gamification points awarded to the user occupying this place at period finalization.
    public var points: Int64?

    public init(
        place: Double? = nil,
        points: Int64? = nil
    ) {
        self.place = place
        self.points = points
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.place = try c.lenientDouble("place")
        self.points = try c.lenientInt64("points")
    }
}
