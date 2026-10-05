// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Extra display payload attached to an activity-log row (`ctx_meta` on the wire).
/// Which keys are present depends on the row's activity type — treat every field
/// as optional and render only what is there.
public struct ActivityLogMeta: Codable, Hashable, Sendable {
    /// Display name of the source entity (mission, tournament, raffle, …).
    public var name: String?
    public var image_url: String?
    public var position: Int64?
    /// Points balance before this row; points rows.
    public var user_points_balance_before: Int64?
    /// Points the awarding rule asked for; points rows.
    public var points_requested: Int64?
    /// Total points ever collected after this row; points rows.
    public var user_points_ever: Int64?
    /// Gems / diamonds the awarding rule asked for; gems / diamonds rows.
    public var amount_requested: Double?
    /// Gems / diamonds balance before this row.
    public var balance_before: Double?
    /// Whether this row counts toward level progress.
    public var affects_level: Bool?
    /// Whether this row counts toward leaderboards.
    public var affects_leaderboard: Bool?
    /// Whether this row moved the spendable balance.
    public var affects_current_balance: Bool?
    /// Set on the row that seeds a brand-new user's wallet.
    public var user_initialization: Bool?
    /// Set on mission rows for repeatable missions.
    public var is_recurring: Bool?
    /// Level moved from; level-change rows.
    public var from_level_id: Int64?
    /// Level moved to; level-change rows.
    public var to_level_id: Int64?
    /// Public meta of the level moved from; level-change rows.
    public var from_level_public_meta: JSON?
    /// Public meta of the level moved to; level-change rows.
    public var to_level_public_meta: JSON?

    public init(
        name: String? = nil,
        image_url: String? = nil,
        position: Int64? = nil,
        user_points_balance_before: Int64? = nil,
        points_requested: Int64? = nil,
        user_points_ever: Int64? = nil,
        amount_requested: Double? = nil,
        balance_before: Double? = nil,
        affects_level: Bool? = nil,
        affects_leaderboard: Bool? = nil,
        affects_current_balance: Bool? = nil,
        user_initialization: Bool? = nil,
        is_recurring: Bool? = nil,
        from_level_id: Int64? = nil,
        to_level_id: Int64? = nil,
        from_level_public_meta: JSON? = nil,
        to_level_public_meta: JSON? = nil
    ) {
        self.name = name
        self.image_url = image_url
        self.position = position
        self.user_points_balance_before = user_points_balance_before
        self.points_requested = points_requested
        self.user_points_ever = user_points_ever
        self.amount_requested = amount_requested
        self.balance_before = balance_before
        self.affects_level = affects_level
        self.affects_leaderboard = affects_leaderboard
        self.affects_current_balance = affects_current_balance
        self.user_initialization = user_initialization
        self.is_recurring = is_recurring
        self.from_level_id = from_level_id
        self.to_level_id = to_level_id
        self.from_level_public_meta = from_level_public_meta
        self.to_level_public_meta = to_level_public_meta
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.image_url = try c.lenientString("image_url")
        self.position = try c.lenientInt64("position")
        self.user_points_balance_before = try c.lenientInt64("user_points_balance_before")
        self.points_requested = try c.lenientInt64("points_requested")
        self.user_points_ever = try c.lenientInt64("user_points_ever")
        self.amount_requested = try c.lenientDouble("amount_requested")
        self.balance_before = try c.lenientDouble("balance_before")
        self.affects_level = try c.lenientBool("affects_level")
        self.affects_leaderboard = try c.lenientBool("affects_leaderboard")
        self.affects_current_balance = try c.lenientBool("affects_current_balance")
        self.user_initialization = try c.lenientBool("user_initialization")
        self.is_recurring = try c.lenientBool("is_recurring")
        self.from_level_id = try c.lenientInt64("from_level_id")
        self.to_level_id = try c.lenientInt64("to_level_id")
        self.from_level_public_meta = try c.lenientJSON("from_level_public_meta")
        self.to_level_public_meta = try c.lenientJSON("to_level_public_meta")
    }
}
