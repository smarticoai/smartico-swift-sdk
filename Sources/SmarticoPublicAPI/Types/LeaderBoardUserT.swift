// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// LeaderBoardUserT describes one participant row on a leaderboard.
public struct LeaderBoardUserT: Codable, Hashable, Sendable {
    /// Display username (operator-defined alias).
    public var public_username: String?
    /// Resolved CDN URL for the participant's avatar. May be empty when the
    /// participant has no custom avatar — fall back to a level-based default
    /// using `level_id`.
    public var avatar_url: String?
    /// The participant's level id — use it to resolve a level-based default
    /// avatar when `avatar_url` is empty.
    public var level_id: Int64?
    /// Rank in the leaderboard (DENSE_RANK over all participants).
    /// `-1` on the `me` entry signals "unranked / outside the window".
    public var position: Int64?
    /// Participant's points for this period.
    public var points: Int64?
    /// `true` when this row is the current authenticated user. Always `true`
    /// on the `me` entry.
    public var is_me: Bool?

    public init(
        public_username: String? = nil,
        avatar_url: String? = nil,
        level_id: Int64? = nil,
        position: Int64? = nil,
        points: Int64? = nil,
        is_me: Bool? = nil
    ) {
        self.public_username = public_username
        self.avatar_url = avatar_url
        self.level_id = level_id
        self.position = position
        self.points = points
        self.is_me = is_me
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.public_username = try c.lenientString("public_username")
        self.avatar_url = try c.lenientString("avatar_url")
        self.level_id = try c.lenientInt64("level_id")
        self.position = try c.lenientInt64("position")
        self.points = try c.lenientInt64("points")
        self.is_me = try c.lenientBool("is_me")
    }
}
