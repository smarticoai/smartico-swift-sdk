// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMissionOrBadgeTask describes the information of tasks that belings to mission or badge. See also TMissionOrBadge
public struct TMissionOrBadgeTask: Codable, Hashable, Sendable {
    /// ID of the task
    public var id: Int64?
    /// Name of the task, translated to the user language
    public var name: String?
    /// Indicator if the task is completed
    public var is_completed: Bool?
    /// The progress of the task in percents
    public var progress: Double?
    /// Reward for completing the task in points
    public var points_reward: Int64?
    /// Reward for completing the task in gems
    public var gems_reward: Double?
    /// Reward for completing the task in diamonds
    public var diamonds_reward: Double?
    /// This is the total number of times the user needs to execute to complete task. e.g. he needs to bet 100 times. Here will be 100
    public var execution_count_expected: Double?
    /// This is the number of times the user has executed 'activity' of the task. e.g. he bet 5 times out of 100. Here will be 5
    public var execution_count_actual: Double?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var display_progress_as_count: Bool?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var stage_image: String?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var priority: Int64?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        is_completed: Bool? = nil,
        progress: Double? = nil,
        points_reward: Int64? = nil,
        gems_reward: Double? = nil,
        diamonds_reward: Double? = nil,
        execution_count_expected: Double? = nil,
        execution_count_actual: Double? = nil,
        display_progress_as_count: Bool? = nil,
        stage_image: String? = nil,
        priority: Int64? = nil
    ) {
        self.id = id
        self.name = name
        self.is_completed = is_completed
        self.progress = progress
        self.points_reward = points_reward
        self.gems_reward = gems_reward
        self.diamonds_reward = diamonds_reward
        self.execution_count_expected = execution_count_expected
        self.execution_count_actual = execution_count_actual
        self.display_progress_as_count = display_progress_as_count
        self.stage_image = stage_image
        self.priority = priority
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.is_completed = try c.lenientBool("is_completed")
        self.progress = try c.lenientDouble("progress")
        self.points_reward = try c.lenientInt64("points_reward")
        self.gems_reward = try c.lenientDouble("gems_reward")
        self.diamonds_reward = try c.lenientDouble("diamonds_reward")
        self.execution_count_expected = try c.lenientDouble("execution_count_expected")
        self.execution_count_actual = try c.lenientDouble("execution_count_actual")
        self.display_progress_as_count = try c.lenientBool("display_progress_as_count")
        self.stage_image = try c.lenientString("stage_image")
        self.priority = try c.lenientInt64("priority")
    }
}
