// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// LeaderBoardSettingsT carries the operator's privacy configuration for
/// leaderboard rendering. Every flag means "hide" when `true`.
public struct LeaderBoardSettingsT: Codable, Hashable, Sendable {
    /// When `true`, render leaderboard rows without player avatars.
    public var hide_avatars: Bool?
    /// When `true`, render leaderboard rows without player level names.
    public var hide_levels: Bool?
    /// When `true`, hide the points of every player except the current user.
    /// The current user's own points are always shown, regardless of this flag.
    public var hide_other_points: Bool?

    public init(
        hide_avatars: Bool? = nil,
        hide_levels: Bool? = nil,
        hide_other_points: Bool? = nil
    ) {
        self.hide_avatars = hide_avatars
        self.hide_levels = hide_levels
        self.hide_other_points = hide_other_points
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.hide_avatars = try c.lenientBool("hide_avatars")
        self.hide_levels = try c.lenientBool("hide_levels")
        self.hide_other_points = try c.lenientBool("hide_other_points")
    }
}
