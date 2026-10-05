// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickBoardUser describes a user's entry on the round leaderboard
public struct GamePickBoardUser: Codable, Hashable, Sendable {
    /// External user ID (Smartico numeric user ID)
    public var ext_user_id: String?
    /// Internal user ID within the games system
    public var int_user_id: Int64?
    /// Display name shown on the leaderboard
    public var public_username: String?
    /// URL of the user's avatar image
    public var avatar_url: String?
    /// User's rank position on the leaderboard, null if not yet ranked
    public var gp_position: Int64?
    /// User's total score in this round/season
    public var resolution_score: Double?
    /// Number of fully correct predictions
    public var full_wins_count: Int64?
    /// Number of partially correct predictions
    public var part_wins_count: Int64?
    /// Number of incorrect predictions
    public var lost_count: Int64?

    public init(
        ext_user_id: String? = nil,
        int_user_id: Int64? = nil,
        public_username: String? = nil,
        avatar_url: String? = nil,
        gp_position: Int64? = nil,
        resolution_score: Double? = nil,
        full_wins_count: Int64? = nil,
        part_wins_count: Int64? = nil,
        lost_count: Int64? = nil
    ) {
        self.ext_user_id = ext_user_id
        self.int_user_id = int_user_id
        self.public_username = public_username
        self.avatar_url = avatar_url
        self.gp_position = gp_position
        self.resolution_score = resolution_score
        self.full_wins_count = full_wins_count
        self.part_wins_count = part_wins_count
        self.lost_count = lost_count
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.int_user_id = try c.lenientInt64("int_user_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_url = try c.lenientString("avatar_url")
        self.gp_position = try c.lenientInt64("gp_position")
        self.resolution_score = try c.lenientDouble("resolution_score")
        self.full_wins_count = try c.lenientInt64("full_wins_count")
        self.part_wins_count = try c.lenientInt64("part_wins_count")
        self.lost_count = try c.lenientInt64("lost_count")
    }
}
