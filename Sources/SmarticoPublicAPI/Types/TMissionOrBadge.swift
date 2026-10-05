// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMissionOrBadge describes the information of mission or badge defined in the system
public struct TMissionOrBadge: Codable, Hashable, Sendable {
    /// ID of the mission or badge
    public var id: Int64?
    /// Type of entity. Can be 'mission' or 'badge'
    public var type: String?
    /// Name of the mission or badge, translated to the user language
    public var name: String?
    /// Sub-header of the mission, translated to the user language
    public var sub_header: String?
    /// Description of the mission or badge, translated to the user language
    public var description: String?
    /// Description of the mission reward if defined
    public var reward: String?
    /// URL of the image of the mission or badge, 256x256px
    public var image: String?
    /// Indicator if the mission is completed or badge is granted. Stays `false` for
    /// Recurring-upon-completion missions even after cycles complete — use `completion_count`
    /// to detect completed cycles (see `getMissions` bucketing).
    public var is_completed: Bool?
    /// Indicator if the mission is locked. Means that it's visible to the user, but he cannot progress in it until it's unlocked.
    /// Mission may optionally contain the explanation of what should be done to unlock it in the unlock_mission_description property
    public var is_locked: Bool?
    /// Optional explaination of what should be done to unlock the mission
    public var unlock_mission_description: String?
    /// Indicator if the mission requires opt-in. Means that user should explicitly opt-in to the mission in order to start progressing in it
    public var is_requires_optin: Bool?
    /// Indicator if the user opted-in to the mission
    public var is_opted_in: Bool?
    /// The amount of time in milliseconds that user has to complete the mission
    public var time_limit_ms: Int64?
    /// Holds time from which mission will become available, for the missions that are targeted to be available from specific date/time
    public var active_from_ts: Int64?
    /// Holds time till mission will become unavailable, for the missions that are targeted to be available from specific date/time
    public var active_till_ts: Int64?
    /// The date when the mission was started, relevant for the time limited missions, also indicating opt-it date for mission that requires opt-in and unlock date for Locked mission.
    public var dt_start: Int64?
    /// The progress of the mission in percents calculated as the aggregated relative percentage of all tasks
    public var progress: Double?
    /// The action that should be performed when user clicks on the mission or badge
    /// Can be URL or deep link, e.g. 'dp:deposit'. The most safe to execute CTA is to pass it to Smartico.dp(cta_action);
    /// The 'dp' function will handle the CTA and will execute it in the most safe way
    public var cta_action: String?
    /// The text of the CTA button, e.g. 'Make a deposit'
    public var cta_text: String?
    /// The ID of the custom section where the mission or badge is assigned.
    /// Resolve to section metadata via `Smartico.api.getCustomSections()`.
    public var custom_section_id: Int64?
    /// The indicator if the mission or badge is visible only in the custom section and should be hidden from the main overview of missions/badges
    public var only_in_custom_section: Bool?
    /// The custom data of the mission or badge defined by operator. Can be a JSON object, string or number
    public var custom_data: JSON?
    /// The list of tasks of the mission or badge
    public var tasks: [TMissionOrBadgeTask]?
    /// List of casino games (or other types of entities) related to the mission or badge
    public var related_games: [AchRelatedGame]?
    /// The list of IDs of the categories where the badge item is assigned, information about categories can be retrieved with getAchCategories method
    public var category_ids: [Int64]?
    /// The T&C text for the missions
    public var hint_text: String?
    /// Priority (or position) of the mission in the UI. Low value indicates higher position in the UI
    public var position: Int64?
    /// The ribbon of the mission/badge item. Can be 'sale', 'hot', 'new', 'vip' or URL to the image in case of custom ribbon, 250x300px
    public var ribbon: JSON?
    /// Stable identifier of this specific mission completion. Undefined for
    /// badges and for missions that have not yet completed.
    public var ach_completed_id: Int64?
    /// Flag from achievement if the mission prize will be given only after user claims it
    public var requires_prize_claim: Bool?
    /// The date/timestamp indicating when the prize was claimed by the user
    public var prize_claimed_date_ts: Int64?
    /// Date-time the mission/badge was completed, as a `"dd/MM/yyyy HH:mm:ss"` string
    /// (server local — NOT ISO-8601, so `new Date(complete_date)` will not parse it).
    /// Prefer the epoch-ms `complete_date_ts` for date math.
    public var complete_date: String?
    /// Time of mission/badge being completed, this property shows the epoch time in UTC
    public var complete_date_ts: Int64?
    /// Flag for mission/badge indicating that mission/badge completed today
    public var completed_today: Bool?
    /// Flag for mission/badge indicating that mission/badge completed this week
    public var completed_this_week: Bool?
    /// Flag for mission/badge indicating that mission/badge completed this month
    public var completed_this_month: Bool?
    /// ID of specific Custom Section type
    public var custom_section_type_id: Int64?
    /// Max number of times the user can complete a mission in case if mission type is Recurring upon completion. NULL equals infinite (still recurring — not "no cap disables recurring").
    public var max_completion_count: Int64?
    /// Current completion count for Recurring-upon-completion missions. Non-null ONLY for that mission type, so its presence identifies one; `> 0` means at least one cycle completed.
    public var completion_count: Int64?
    /// The date/timestamp for recurring missions, which indicating the time remaining until the next recurrence of the mission.
    /// Note that if a mission has an "Active till" date defined, this field is not relevant after that date.
    public var next_recurrence_date_ts: Int64?
    /// Timer/window state derived from the mission's time limits (which countdown to show / whether the window elapsed). NOT a tab-bucketing signal — it ignores `completion_count`, so bucket sections from the raw fields instead (see `getMissions`).
    public var availability_status: Int64?
    /// Title for the claim reward button
    public var claim_button_title: String?
    /// Action for the claim reward button
    public var claim_button_action: String?
    /// The date/timestamp indicating when the mission claim will expire
    public var prize_claim_expiration_date: Int64?
    /// The type of the prize claim period (Relative or Exact time and date)
    public var prize_claim_period_type_id: Int64?
    /// Badge time limit state for badges with time restrictions
    public var badgeTimeLimitState: Int64?
    /// Flag from achievement if the mission should be hidden when it is locked, until it's unlocked
    public var hide_locked_mission: Bool?

    public init(
        id: Int64? = nil,
        type: String? = nil,
        name: String? = nil,
        sub_header: String? = nil,
        description: String? = nil,
        reward: String? = nil,
        image: String? = nil,
        is_completed: Bool? = nil,
        is_locked: Bool? = nil,
        unlock_mission_description: String? = nil,
        is_requires_optin: Bool? = nil,
        is_opted_in: Bool? = nil,
        time_limit_ms: Int64? = nil,
        active_from_ts: Int64? = nil,
        active_till_ts: Int64? = nil,
        dt_start: Int64? = nil,
        progress: Double? = nil,
        cta_action: String? = nil,
        cta_text: String? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        custom_data: JSON? = nil,
        tasks: [TMissionOrBadgeTask]? = nil,
        related_games: [AchRelatedGame]? = nil,
        category_ids: [Int64]? = nil,
        hint_text: String? = nil,
        position: Int64? = nil,
        ribbon: JSON? = nil,
        ach_completed_id: Int64? = nil,
        requires_prize_claim: Bool? = nil,
        prize_claimed_date_ts: Int64? = nil,
        complete_date: String? = nil,
        complete_date_ts: Int64? = nil,
        completed_today: Bool? = nil,
        completed_this_week: Bool? = nil,
        completed_this_month: Bool? = nil,
        custom_section_type_id: Int64? = nil,
        max_completion_count: Int64? = nil,
        completion_count: Int64? = nil,
        next_recurrence_date_ts: Int64? = nil,
        availability_status: Int64? = nil,
        claim_button_title: String? = nil,
        claim_button_action: String? = nil,
        prize_claim_expiration_date: Int64? = nil,
        prize_claim_period_type_id: Int64? = nil,
        badgeTimeLimitState: Int64? = nil,
        hide_locked_mission: Bool? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.sub_header = sub_header
        self.description = description
        self.reward = reward
        self.image = image
        self.is_completed = is_completed
        self.is_locked = is_locked
        self.unlock_mission_description = unlock_mission_description
        self.is_requires_optin = is_requires_optin
        self.is_opted_in = is_opted_in
        self.time_limit_ms = time_limit_ms
        self.active_from_ts = active_from_ts
        self.active_till_ts = active_till_ts
        self.dt_start = dt_start
        self.progress = progress
        self.cta_action = cta_action
        self.cta_text = cta_text
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.custom_data = custom_data
        self.tasks = tasks
        self.related_games = related_games
        self.category_ids = category_ids
        self.hint_text = hint_text
        self.position = position
        self.ribbon = ribbon
        self.ach_completed_id = ach_completed_id
        self.requires_prize_claim = requires_prize_claim
        self.prize_claimed_date_ts = prize_claimed_date_ts
        self.complete_date = complete_date
        self.complete_date_ts = complete_date_ts
        self.completed_today = completed_today
        self.completed_this_week = completed_this_week
        self.completed_this_month = completed_this_month
        self.custom_section_type_id = custom_section_type_id
        self.max_completion_count = max_completion_count
        self.completion_count = completion_count
        self.next_recurrence_date_ts = next_recurrence_date_ts
        self.availability_status = availability_status
        self.claim_button_title = claim_button_title
        self.claim_button_action = claim_button_action
        self.prize_claim_expiration_date = prize_claim_expiration_date
        self.prize_claim_period_type_id = prize_claim_period_type_id
        self.badgeTimeLimitState = badgeTimeLimitState
        self.hide_locked_mission = hide_locked_mission
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.type = try c.lenientString("type")
        self.name = try c.lenientString("name")
        self.sub_header = try c.lenientString("sub_header")
        self.description = try c.lenientString("description")
        self.reward = try c.lenientString("reward")
        self.image = try c.lenientString("image")
        self.is_completed = try c.lenientBool("is_completed")
        self.is_locked = try c.lenientBool("is_locked")
        self.unlock_mission_description = try c.lenientString("unlock_mission_description")
        self.is_requires_optin = try c.lenientBool("is_requires_optin")
        self.is_opted_in = try c.lenientBool("is_opted_in")
        self.time_limit_ms = try c.lenientInt64("time_limit_ms")
        self.active_from_ts = try c.lenientInt64("active_from_ts")
        self.active_till_ts = try c.lenientInt64("active_till_ts")
        self.dt_start = try c.lenientInt64("dt_start")
        self.progress = try c.lenientDouble("progress")
        self.cta_action = try c.lenientString("cta_action")
        self.cta_text = try c.lenientString("cta_text")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.custom_data = try c.lenientJSON("custom_data")
        self.tasks = try c.lenientList(TMissionOrBadgeTask.self, "tasks")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.category_ids = try c.lenientList(Int64.self, "category_ids")
        self.hint_text = try c.lenientString("hint_text")
        self.position = try c.lenientInt64("position")
        self.ribbon = try c.lenientJSON("ribbon")
        self.ach_completed_id = try c.lenientInt64("ach_completed_id")
        self.requires_prize_claim = try c.lenientBool("requires_prize_claim")
        self.prize_claimed_date_ts = try c.lenientInt64("prize_claimed_date_ts")
        self.complete_date = try c.lenientString("complete_date")
        self.complete_date_ts = try c.lenientInt64("complete_date_ts")
        self.completed_today = try c.lenientBool("completed_today")
        self.completed_this_week = try c.lenientBool("completed_this_week")
        self.completed_this_month = try c.lenientBool("completed_this_month")
        self.custom_section_type_id = try c.lenientInt64("custom_section_type_id")
        self.max_completion_count = try c.lenientInt64("max_completion_count")
        self.completion_count = try c.lenientInt64("completion_count")
        self.next_recurrence_date_ts = try c.lenientInt64("next_recurrence_date_ts")
        self.availability_status = try c.lenientInt64("availability_status")
        self.claim_button_title = try c.lenientString("claim_button_title")
        self.claim_button_action = try c.lenientString("claim_button_action")
        self.prize_claim_expiration_date = try c.lenientInt64("prize_claim_expiration_date")
        self.prize_claim_period_type_id = try c.lenientInt64("prize_claim_period_type_id")
        self.badgeTimeLimitState = try c.lenientInt64("badgeTimeLimitState")
        self.hide_locked_mission = try c.lenientBool("hide_locked_mission")
    }
}
