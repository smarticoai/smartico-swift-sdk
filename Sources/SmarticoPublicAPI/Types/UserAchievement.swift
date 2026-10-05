// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct UserAchievement: Codable, Hashable, Sendable {
    public var ach_id: Int64?
    public var ach_type_id: Int64?
    public var ach_public_meta: AchievementPublicMeta?
    public var isCompleted: Bool?
    public var isLocked: Bool?
    public var requiresOptin: Bool?
    public var isOptedIn: Bool?
    public var start_date: String?
    public var start_date_ts: Int64?
    public var time_limit_ms: Int64?
    public var progress: Double?
    public var complete_date: String?
    public var complete_date_ts: Int64?
    public var unlock_date: String?
    public var milliseconds_till_available: Int64?
    public var completed_tasks: Double?
    public var achievementTasks: [UserAchievementTask]?
    public var next_recurrence_date_ts: Int64?
    public var ach_status_id: Int64?
    public var scheduledMissionType: Int64?
    public var related_games: [AchRelatedGame]?
    public var active_from_ts: Int64?
    public var active_till_ts: Int64?
    public var ach_categories: [Double]?
    public var recurring_quantity: Double?
    public var completed_count: Int64?
    public var ach_completed_id: Int64?
    public var requires_prize_claim: Bool?
    public var prize_claimed_date_ts: Int64?
    public var completed_today: Bool?
    public var completed_this_week: Bool?
    public var completed_this_month: Bool?
    public var custom_section_type_id: Int64?
    public var badgeTimeLimitState: Int64?
    public var prize_claim_expiration_date: Int64?
    public var prize_claim_period_type_id: Int64?

    public init(
        ach_id: Int64? = nil,
        ach_type_id: Int64? = nil,
        ach_public_meta: AchievementPublicMeta? = nil,
        isCompleted: Bool? = nil,
        isLocked: Bool? = nil,
        requiresOptin: Bool? = nil,
        isOptedIn: Bool? = nil,
        start_date: String? = nil,
        start_date_ts: Int64? = nil,
        time_limit_ms: Int64? = nil,
        progress: Double? = nil,
        complete_date: String? = nil,
        complete_date_ts: Int64? = nil,
        unlock_date: String? = nil,
        milliseconds_till_available: Int64? = nil,
        completed_tasks: Double? = nil,
        achievementTasks: [UserAchievementTask]? = nil,
        next_recurrence_date_ts: Int64? = nil,
        ach_status_id: Int64? = nil,
        scheduledMissionType: Int64? = nil,
        related_games: [AchRelatedGame]? = nil,
        active_from_ts: Int64? = nil,
        active_till_ts: Int64? = nil,
        ach_categories: [Double]? = nil,
        recurring_quantity: Double? = nil,
        completed_count: Int64? = nil,
        ach_completed_id: Int64? = nil,
        requires_prize_claim: Bool? = nil,
        prize_claimed_date_ts: Int64? = nil,
        completed_today: Bool? = nil,
        completed_this_week: Bool? = nil,
        completed_this_month: Bool? = nil,
        custom_section_type_id: Int64? = nil,
        badgeTimeLimitState: Int64? = nil,
        prize_claim_expiration_date: Int64? = nil,
        prize_claim_period_type_id: Int64? = nil
    ) {
        self.ach_id = ach_id
        self.ach_type_id = ach_type_id
        self.ach_public_meta = ach_public_meta
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.requiresOptin = requiresOptin
        self.isOptedIn = isOptedIn
        self.start_date = start_date
        self.start_date_ts = start_date_ts
        self.time_limit_ms = time_limit_ms
        self.progress = progress
        self.complete_date = complete_date
        self.complete_date_ts = complete_date_ts
        self.unlock_date = unlock_date
        self.milliseconds_till_available = milliseconds_till_available
        self.completed_tasks = completed_tasks
        self.achievementTasks = achievementTasks
        self.next_recurrence_date_ts = next_recurrence_date_ts
        self.ach_status_id = ach_status_id
        self.scheduledMissionType = scheduledMissionType
        self.related_games = related_games
        self.active_from_ts = active_from_ts
        self.active_till_ts = active_till_ts
        self.ach_categories = ach_categories
        self.recurring_quantity = recurring_quantity
        self.completed_count = completed_count
        self.ach_completed_id = ach_completed_id
        self.requires_prize_claim = requires_prize_claim
        self.prize_claimed_date_ts = prize_claimed_date_ts
        self.completed_today = completed_today
        self.completed_this_week = completed_this_week
        self.completed_this_month = completed_this_month
        self.custom_section_type_id = custom_section_type_id
        self.badgeTimeLimitState = badgeTimeLimitState
        self.prize_claim_expiration_date = prize_claim_expiration_date
        self.prize_claim_period_type_id = prize_claim_period_type_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ach_id = try c.lenientInt64("ach_id")
        self.ach_type_id = try c.lenientInt64("ach_type_id")
        self.ach_public_meta = try c.lenientObject(AchievementPublicMeta.self, "ach_public_meta")
        self.isCompleted = try c.lenientBool("isCompleted")
        self.isLocked = try c.lenientBool("isLocked")
        self.requiresOptin = try c.lenientBool("requiresOptin")
        self.isOptedIn = try c.lenientBool("isOptedIn")
        self.start_date = try c.lenientString("start_date")
        self.start_date_ts = try c.lenientInt64("start_date_ts")
        self.time_limit_ms = try c.lenientInt64("time_limit_ms")
        self.progress = try c.lenientDouble("progress")
        self.complete_date = try c.lenientString("complete_date")
        self.complete_date_ts = try c.lenientInt64("complete_date_ts")
        self.unlock_date = try c.lenientString("unlock_date")
        self.milliseconds_till_available = try c.lenientInt64("milliseconds_till_available")
        self.completed_tasks = try c.lenientDouble("completed_tasks")
        self.achievementTasks = try c.lenientList(UserAchievementTask.self, "achievementTasks")
        self.next_recurrence_date_ts = try c.lenientInt64("next_recurrence_date_ts")
        self.ach_status_id = try c.lenientInt64("ach_status_id")
        self.scheduledMissionType = try c.lenientInt64("scheduledMissionType")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.active_from_ts = try c.lenientInt64("active_from_ts")
        self.active_till_ts = try c.lenientInt64("active_till_ts")
        self.ach_categories = try c.lenientList(Double.self, "ach_categories")
        self.recurring_quantity = try c.lenientDouble("recurring_quantity")
        self.completed_count = try c.lenientInt64("completed_count")
        self.ach_completed_id = try c.lenientInt64("ach_completed_id")
        self.requires_prize_claim = try c.lenientBool("requires_prize_claim")
        self.prize_claimed_date_ts = try c.lenientInt64("prize_claimed_date_ts")
        self.completed_today = try c.lenientBool("completed_today")
        self.completed_this_week = try c.lenientBool("completed_this_week")
        self.completed_this_month = try c.lenientBool("completed_this_month")
        self.custom_section_type_id = try c.lenientInt64("custom_section_type_id")
        self.badgeTimeLimitState = try c.lenientInt64("badgeTimeLimitState")
        self.prize_claim_expiration_date = try c.lenientInt64("prize_claim_expiration_date")
        self.prize_claim_period_type_id = try c.lenientInt64("prize_claim_period_type_id")
    }
}
