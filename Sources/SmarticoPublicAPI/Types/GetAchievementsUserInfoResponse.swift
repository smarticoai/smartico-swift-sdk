// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetAchievementsUserInfoResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    public var level_counter_1: Int64?
    public var level_counter_2: Int64?
    public var points_balance: Int64?
    public var gems_balance: Double?
    public var diamonds_balance: Double?
    public var points_ever: Int64?
    public var current_level: Int64?
    public var points_board_period_type_1: Int64?
    public var points_board_period_type_2: Int64?
    public var points_board_period_type_3: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        level_counter_1: Int64? = nil,
        level_counter_2: Int64? = nil,
        points_balance: Int64? = nil,
        gems_balance: Double? = nil,
        diamonds_balance: Double? = nil,
        points_ever: Int64? = nil,
        current_level: Int64? = nil,
        points_board_period_type_1: Int64? = nil,
        points_board_period_type_2: Int64? = nil,
        points_board_period_type_3: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.level_counter_1 = level_counter_1
        self.level_counter_2 = level_counter_2
        self.points_balance = points_balance
        self.gems_balance = gems_balance
        self.diamonds_balance = diamonds_balance
        self.points_ever = points_ever
        self.current_level = current_level
        self.points_board_period_type_1 = points_board_period_type_1
        self.points_board_period_type_2 = points_board_period_type_2
        self.points_board_period_type_3 = points_board_period_type_3
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.level_counter_1 = try c.lenientInt64("level_counter_1")
        self.level_counter_2 = try c.lenientInt64("level_counter_2")
        self.points_balance = try c.lenientInt64("points_balance")
        self.gems_balance = try c.lenientDouble("gems_balance")
        self.diamonds_balance = try c.lenientDouble("diamonds_balance")
        self.points_ever = try c.lenientInt64("points_ever")
        self.current_level = try c.lenientInt64("current_level")
        self.points_board_period_type_1 = try c.lenientInt64("points_board_period_type_1")
        self.points_board_period_type_2 = try c.lenientInt64("points_board_period_type_2")
        self.points_board_period_type_3 = try c.lenientInt64("points_board_period_type_3")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
