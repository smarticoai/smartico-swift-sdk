// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickUserInfo describes the current user's profile in the games system
public struct GamePickUserInfo: Codable, Hashable, Sendable {
    /// External user ID (Smartico numeric user ID)
    public var ext_user_id: String?
    /// Internal user ID within the games system
    public var int_user_id: Int64?
    /// Display name
    public var public_username: String?
    /// URL of the user's avatar image
    public var avatar_url: String?
    /// User's leaderboard rank position
    public var gp_position: Int64?
    /// Number of fully correct predictions
    public var full_wins_count: Int64?
    /// Number of partially correct predictions
    public var part_wins_count: Int64?
    /// User's total score
    public var resolution_score: Double?
    /// ISO 8601 date-time string of the last time the user's balance was synced from the Smartico platform.
    public var last_wallet_sync_time: String?
    /// User's current points balance
    public var ach_points_balance: Int64?
    /// User's current gems balance
    public var ach_gems_balance: Double?
    /// User's current diamonds balance
    public var ach_diamonds_balance: Double?
    /// Whether the user has set a custom public username
    public var pubic_username_set: Bool?

    public init(
        ext_user_id: String? = nil,
        int_user_id: Int64? = nil,
        public_username: String? = nil,
        avatar_url: String? = nil,
        gp_position: Int64? = nil,
        full_wins_count: Int64? = nil,
        part_wins_count: Int64? = nil,
        resolution_score: Double? = nil,
        last_wallet_sync_time: String? = nil,
        ach_points_balance: Int64? = nil,
        ach_gems_balance: Double? = nil,
        ach_diamonds_balance: Double? = nil,
        pubic_username_set: Bool? = nil
    ) {
        self.ext_user_id = ext_user_id
        self.int_user_id = int_user_id
        self.public_username = public_username
        self.avatar_url = avatar_url
        self.gp_position = gp_position
        self.full_wins_count = full_wins_count
        self.part_wins_count = part_wins_count
        self.resolution_score = resolution_score
        self.last_wallet_sync_time = last_wallet_sync_time
        self.ach_points_balance = ach_points_balance
        self.ach_gems_balance = ach_gems_balance
        self.ach_diamonds_balance = ach_diamonds_balance
        self.pubic_username_set = pubic_username_set
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.int_user_id = try c.lenientInt64("int_user_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_url = try c.lenientString("avatar_url")
        self.gp_position = try c.lenientInt64("gp_position")
        self.full_wins_count = try c.lenientInt64("full_wins_count")
        self.part_wins_count = try c.lenientInt64("part_wins_count")
        self.resolution_score = try c.lenientDouble("resolution_score")
        self.last_wallet_sync_time = try c.lenientString("last_wallet_sync_time")
        self.ach_points_balance = try c.lenientInt64("ach_points_balance")
        self.ach_gems_balance = try c.lenientDouble("ach_gems_balance")
        self.ach_diamonds_balance = try c.lenientDouble("ach_diamonds_balance")
        self.pubic_username_set = try c.lenientBool("pubic_username_set")
    }
}
