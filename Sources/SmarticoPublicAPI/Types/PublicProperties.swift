// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct PublicProperties: Codable, Hashable, Sendable {
    public var core_user_language: String?
    public var ach_points_balance: Int64?
    public var ach_points_ever: Int64?
    public var ach_gems_balance: Double?
    public var ach_diamonds_balance: Double?
    public var ach_level_current_id: Int64?
    public var ach_level_current: String?
    public var core_is_test_account: Bool?
    public var ach_gamification_in_control_group: Bool?

    public init(
        core_user_language: String? = nil,
        ach_points_balance: Int64? = nil,
        ach_points_ever: Int64? = nil,
        ach_gems_balance: Double? = nil,
        ach_diamonds_balance: Double? = nil,
        ach_level_current_id: Int64? = nil,
        ach_level_current: String? = nil,
        core_is_test_account: Bool? = nil,
        ach_gamification_in_control_group: Bool? = nil
    ) {
        self.core_user_language = core_user_language
        self.ach_points_balance = ach_points_balance
        self.ach_points_ever = ach_points_ever
        self.ach_gems_balance = ach_gems_balance
        self.ach_diamonds_balance = ach_diamonds_balance
        self.ach_level_current_id = ach_level_current_id
        self.ach_level_current = ach_level_current
        self.core_is_test_account = core_is_test_account
        self.ach_gamification_in_control_group = ach_gamification_in_control_group
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.core_user_language = try c.lenientString("core_user_language")
        self.ach_points_balance = try c.lenientInt64("ach_points_balance")
        self.ach_points_ever = try c.lenientInt64("ach_points_ever")
        self.ach_gems_balance = try c.lenientDouble("ach_gems_balance")
        self.ach_diamonds_balance = try c.lenientDouble("ach_diamonds_balance")
        self.ach_level_current_id = try c.lenientInt64("ach_level_current_id")
        self.ach_level_current = try c.lenientString("ach_level_current")
        self.core_is_test_account = try c.lenientBool("core_is_test_account")
        self.ach_gamification_in_control_group = try c.lenientBool("ach_gamification_in_control_group")
    }
}
