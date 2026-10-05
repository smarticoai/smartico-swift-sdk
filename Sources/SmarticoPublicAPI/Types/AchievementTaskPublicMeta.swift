// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AchievementTaskPublicMeta: Codable, Hashable, Sendable {
    public var name: String?
    public var display_progress_as_count: Bool?
    public var stage_image: String?
    public var priority: Int64?
    public var user_state_operations: JSON?

    public init(
        name: String? = nil,
        display_progress_as_count: Bool? = nil,
        stage_image: String? = nil,
        priority: Int64? = nil,
        user_state_operations: JSON? = nil
    ) {
        self.name = name
        self.display_progress_as_count = display_progress_as_count
        self.stage_image = stage_image
        self.priority = priority
        self.user_state_operations = user_state_operations
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.display_progress_as_count = try c.lenientBool("display_progress_as_count")
        self.stage_image = try c.lenientString("stage_image")
        self.priority = try c.lenientInt64("priority")
        self.user_state_operations = try c.lenientJSON("user_state_operations")
    }
}
