// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TLevelCurrent extends `TLevel` with the user's progress toward the next level.
/// Returned by `Smartico.api.getCurrentLevel()`.
public struct TLevelCurrent: Codable, Hashable, Sendable {
    /// Stable ID of the level.
    public var id: Int64?
    /// Display name of the level, pre-translated to the user's language.
    public var name: String?
    /// Display description of the level, pre-translated to the user's language.
    public var description: String?
    /// URL of the level image (256x256 px source).
    public var image: String?
    /// Total `ach_points_ever` required to reach this level.
    public var required_points: Int64?
    /// Visibility threshold — clients hide the level from the user until
    /// `ach_points_ever >= visibility_points`. `null` means always visible.
    public var visibility_points: Int64?
    /// Required value of the first level counter for sliding-window leveling.
    /// `null` on points-only labels. See `UserLevelExtraCountersT`.
    public var required_level_counter_1: Int64?
    /// Required value of the second level counter for sliding-window leveling.
    /// `null` on points-only labels.
    public var required_level_counter_2: Int64?
    /// Operator-defined custom data. The SDK auto-parses JSON-looking
    /// strings, so at runtime this is `any` despite the `string` type.
    public var custom_data: String?
    /// 1-based position in the ladder (matches the order of the returned
    /// array, which is sorted by `required_points` ASC).
    public var ordinal_position: Int64?
    /// Progress to the next level as a 0–100 integer percentage. `100`
    /// at the highest level.
    public var progress: Double?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        image: String? = nil,
        required_points: Int64? = nil,
        visibility_points: Int64? = nil,
        required_level_counter_1: Int64? = nil,
        required_level_counter_2: Int64? = nil,
        custom_data: String? = nil,
        ordinal_position: Int64? = nil,
        progress: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.required_points = required_points
        self.visibility_points = visibility_points
        self.required_level_counter_1 = required_level_counter_1
        self.required_level_counter_2 = required_level_counter_2
        self.custom_data = custom_data
        self.ordinal_position = ordinal_position
        self.progress = progress
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image = try c.lenientString("image")
        self.required_points = try c.lenientInt64("required_points")
        self.visibility_points = try c.lenientInt64("visibility_points")
        self.required_level_counter_1 = try c.lenientInt64("required_level_counter_1")
        self.required_level_counter_2 = try c.lenientInt64("required_level_counter_2")
        self.custom_data = try c.lenientString("custom_data")
        self.ordinal_position = try c.lenientInt64("ordinal_position")
        self.progress = try c.lenientDouble("progress")
    }
}
// Inherited fields from TLevel are flattened above.
