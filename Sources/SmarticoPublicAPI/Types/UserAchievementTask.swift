// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct UserAchievementTask: Codable, Hashable, Sendable {
    public var task_id: Int64?
    public var task_public_meta: AchievementTaskPublicMeta?
    public var points_reward: Int64?
    /// Gems awarded when this task is completed.
    public var gems_reward: Double?
    /// Diamonds awarded when this task is completed.
    public var diamonds_reward: Double?
    public var task_type_id: Int64?
    public var isCompleted: Bool?
    public var userExecutedCount: Int64?
    public var executionCount: Int64?
    public var userProgress: Double?
    public var lastExecutionDate: String?
    public var unlocked_by_mission_id: Int64?
    public var unlocked_by_level_id: Int64?
    public var user_state_params: JSON?
    public var affects_progress: AffectsProgress?

    public init(
        task_id: Int64? = nil,
        task_public_meta: AchievementTaskPublicMeta? = nil,
        points_reward: Int64? = nil,
        gems_reward: Double? = nil,
        diamonds_reward: Double? = nil,
        task_type_id: Int64? = nil,
        isCompleted: Bool? = nil,
        userExecutedCount: Int64? = nil,
        executionCount: Int64? = nil,
        userProgress: Double? = nil,
        lastExecutionDate: String? = nil,
        unlocked_by_mission_id: Int64? = nil,
        unlocked_by_level_id: Int64? = nil,
        user_state_params: JSON? = nil,
        affects_progress: AffectsProgress? = nil
    ) {
        self.task_id = task_id
        self.task_public_meta = task_public_meta
        self.points_reward = points_reward
        self.gems_reward = gems_reward
        self.diamonds_reward = diamonds_reward
        self.task_type_id = task_type_id
        self.isCompleted = isCompleted
        self.userExecutedCount = userExecutedCount
        self.executionCount = executionCount
        self.userProgress = userProgress
        self.lastExecutionDate = lastExecutionDate
        self.unlocked_by_mission_id = unlocked_by_mission_id
        self.unlocked_by_level_id = unlocked_by_level_id
        self.user_state_params = user_state_params
        self.affects_progress = affects_progress
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.task_id = try c.lenientInt64("task_id")
        self.task_public_meta = try c.lenientObject(AchievementTaskPublicMeta.self, "task_public_meta")
        self.points_reward = try c.lenientInt64("points_reward")
        self.gems_reward = try c.lenientDouble("gems_reward")
        self.diamonds_reward = try c.lenientDouble("diamonds_reward")
        self.task_type_id = try c.lenientInt64("task_type_id")
        self.isCompleted = try c.lenientBool("isCompleted")
        self.userExecutedCount = try c.lenientInt64("userExecutedCount")
        self.executionCount = try c.lenientInt64("executionCount")
        self.userProgress = try c.lenientDouble("userProgress")
        self.lastExecutionDate = try c.lenientString("lastExecutionDate")
        self.unlocked_by_mission_id = try c.lenientInt64("unlocked_by_mission_id")
        self.unlocked_by_level_id = try c.lenientInt64("unlocked_by_level_id")
        self.user_state_params = try c.lenientJSON("user_state_params")
        self.affects_progress = try c.lenientObject(AffectsProgress.self, "affects_progress")
    }
}
