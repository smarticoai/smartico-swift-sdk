// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct Level: Codable, Hashable, Sendable {
    public var level_id: Int64?
    public var level_public_meta: LevelPublicMeta?
    public var required_points: Int64?
    public var is_first_level: Bool?
    /// Internal status of level. Not in use right now on the front-end
    public var level_status_id: Int64?
    public var required_level_counter_1: Int64?
    public var required_level_counter_2: Int64?
    public var general_level_progress: Int64?
    /// 1-based position of this level within the level ladder.
    public var ordinal_position: Int64?

    public init(
        level_id: Int64? = nil,
        level_public_meta: LevelPublicMeta? = nil,
        required_points: Int64? = nil,
        is_first_level: Bool? = nil,
        level_status_id: Int64? = nil,
        required_level_counter_1: Int64? = nil,
        required_level_counter_2: Int64? = nil,
        general_level_progress: Int64? = nil,
        ordinal_position: Int64? = nil
    ) {
        self.level_id = level_id
        self.level_public_meta = level_public_meta
        self.required_points = required_points
        self.is_first_level = is_first_level
        self.level_status_id = level_status_id
        self.required_level_counter_1 = required_level_counter_1
        self.required_level_counter_2 = required_level_counter_2
        self.general_level_progress = general_level_progress
        self.ordinal_position = ordinal_position
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.level_id = try c.lenientInt64("level_id")
        self.level_public_meta = try c.lenientObject(LevelPublicMeta.self, "level_public_meta")
        self.required_points = try c.lenientInt64("required_points")
        self.is_first_level = try c.lenientBool("is_first_level")
        self.level_status_id = try c.lenientInt64("level_status_id")
        self.required_level_counter_1 = try c.lenientInt64("required_level_counter_1")
        self.required_level_counter_2 = try c.lenientInt64("required_level_counter_2")
        self.general_level_progress = try c.lenientInt64("general_level_progress")
        self.ordinal_position = try c.lenientInt64("ordinal_position")
    }
}
