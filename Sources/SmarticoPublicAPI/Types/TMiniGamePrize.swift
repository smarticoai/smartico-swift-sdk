// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMiniGamePrize describes the information of prize in the array of prizes in the TMiniGameTemplate
public struct TMiniGamePrize: Codable, Hashable, Sendable {
    /// ID of the prize
    public var id: Int64?
    /// Display name of the prize, pre-translated; any jackpot placeholder in it arrives resolved to the live jackpot value
    public var name: String?
    /// The type of the prize — see {@link MiniGamePrizeTypeName} ('no-prize', 'points', 'gems-and-diamonds', 'spin', 'bonus', 'jackpot', 'raffle-ticket', 'mission', 'change-level', 'manual')
    public var prize_type: String?
    /// Numeric value of the prize in case it's 'points' or 'spin' type. For other types of prizes this value is not relevant.
    /// For example for prize  '100 points' the prize_value will be 100. For '100 free spins' the prize_value will be 100.
    public var prize_value: Double?
    /// Custom font size in px for rendering the prize name on the game surface (e.g. a wheel sector), desktop
    public var font_size: Double?
    /// Custom font size in px for the prize name, mobile; falls back to `font_size` when absent
    public var font_size_mobile: Double?
    /// The URL of the icon of the prize, aspect ratio 1:1
    public var icon: String?
    /// For Scratch Card games — relative order of the prize in the scratch grid (lower first). May be absent for other game types
    public var position: Int64?
    /// For Spin-a-Wheel games — wheel sector indices this prize occupies. Absent for non-wheel games
    public var sectors: [Double]?
    /// Which win modal the prize uses — see {@link SAWAcknowledgeTypeName} (Silent / QuickMessage / FullMessage / ExplicitAcknowledge)
    public var acknowledge_type: String?
    /// Message that will be shown to user in modal pop-up
    public var aknowledge_message: String?
    /// Message shown instead of `aknowledge_message` when the spin is finalised as lost (`lose: true` acknowledge flows — games with a client-decided outcome, e.g. Voyager). Absent unless configured
    public var aknowledge_message_lose: String?
    /// Deep link executed when the user taps the main action button in the win modal (run it via `Smartico.dp()`)
    public var acknowledge_dp: String?
    /// Label of the main action button in the win modal
    public var acknowledge_action_title: String?
    /// Deep link of the additional action button in the win modal
    public var acknowledge_dp_additional: String?
    /// Label of the additional action button in the win modal
    public var acknowledge_action_title_additional: String?
    /// Deep link of the secondary button in the win modal
    public var second_btn: String?
    /// Label of the secondary button in the win modal
    public var second_btn_action_title: String?
    /// Message when the prize pool is empty for that specific prize
    public var out_of_stock_message: String?
    /// Remaining stock of the prize — decrements on each win, refunded if the spin is finalised as lost. Populated only when the template's `expose_game_stat_on_api` is enabled; always populated for MatchX / Quiz games
    public var pool: Double?
    /// Initial (configured) stock of the prize. Populated regardless of `expose_game_stat_on_api`
    public var pool_initial: Double?
    /// Number of times the prize has been won, across all players. Populated only when the template's `expose_game_stat_on_api` is enabled
    public var wins_count: Int64?
    /// ISO weekday numbers (1 = Monday … 7 = Sunday) on which the prize can be won; absent = any day. Populated only when the template's `expose_game_stat_on_api` is enabled
    public var weekdays: [Int64]?
    /// Time from which the prize can be won (epoch ms), evaluated against `relative_period_timezone`. Populated only when the template's `expose_game_stat_on_api` is enabled
    public var active_from_ts: Int64?
    /// Time until which the prize can be won (epoch ms), evaluated against `relative_period_timezone`. Populated only when the template's `expose_game_stat_on_api` is enabled
    public var active_till_ts: Int64?
    /// Timezone offset in minutes used to evaluate `weekdays` and the active window (UTC minus local — e.g. `-180` for UTC+3)
    public var relative_period_timezone: Double?
    /// When true, the prize stays winnable even when its `pool` reaches 0 (effectively unlimited stock)
    public var is_surcharge: Bool?
    /// Always `false` in API responses — deleted prizes are excluded server-side
    public var is_deleted: Bool?
    /// The custom data of the prize defined by the operator. Can be a JSON object, string or number
    public var custom_data: JSON?
    /// Step-modifier tiles for step games (Treasure Hunt / Voyager) — see {@link PrizeModifiers} (2x / 5x / 10x, /2 / /5 / /10, 0, reset) applied to the running total revealed during the game. Presentation only — the awarded amount is still `prize_value`
    public var prize_modifiers: [String]?
    /// Step games (Treasure Hunt / Voyager): when true, the per-step revealed amounts of the prize value may be fractional; when false the split uses whole numbers
    public var allow_split_decimal: Bool?
    /// Operator hint to hide this prize when rendering prize-history UIs. Informational only — API responses are not filtered by it
    public var hide_prize_from_history: Bool?
    /// Operator text describing what the user must do to be eligible for this prize (lootbox games); shown when the prize is not yet available to the user
    public var requirements_to_get_prize: String?
    /// Period basis for the prize availability restriction — see {@link AttemptPeriodType}. `CalendarDaysUserTimeZone` evaluates `weekdays` / the active window in the user's timezone; the other types use `relative_period_timezone`
    public var max_give_period_type_id: Int64?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        prize_type: String? = nil,
        prize_value: Double? = nil,
        font_size: Double? = nil,
        font_size_mobile: Double? = nil,
        icon: String? = nil,
        position: Int64? = nil,
        sectors: [Double]? = nil,
        acknowledge_type: String? = nil,
        aknowledge_message: String? = nil,
        aknowledge_message_lose: String? = nil,
        acknowledge_dp: String? = nil,
        acknowledge_action_title: String? = nil,
        acknowledge_dp_additional: String? = nil,
        acknowledge_action_title_additional: String? = nil,
        second_btn: String? = nil,
        second_btn_action_title: String? = nil,
        out_of_stock_message: String? = nil,
        pool: Double? = nil,
        pool_initial: Double? = nil,
        wins_count: Int64? = nil,
        weekdays: [Int64]? = nil,
        active_from_ts: Int64? = nil,
        active_till_ts: Int64? = nil,
        relative_period_timezone: Double? = nil,
        is_surcharge: Bool? = nil,
        is_deleted: Bool? = nil,
        custom_data: JSON? = nil,
        prize_modifiers: [String]? = nil,
        allow_split_decimal: Bool? = nil,
        hide_prize_from_history: Bool? = nil,
        requirements_to_get_prize: String? = nil,
        max_give_period_type_id: Int64? = nil
    ) {
        self.id = id
        self.name = name
        self.prize_type = prize_type
        self.prize_value = prize_value
        self.font_size = font_size
        self.font_size_mobile = font_size_mobile
        self.icon = icon
        self.position = position
        self.sectors = sectors
        self.acknowledge_type = acknowledge_type
        self.aknowledge_message = aknowledge_message
        self.aknowledge_message_lose = aknowledge_message_lose
        self.acknowledge_dp = acknowledge_dp
        self.acknowledge_action_title = acknowledge_action_title
        self.acknowledge_dp_additional = acknowledge_dp_additional
        self.acknowledge_action_title_additional = acknowledge_action_title_additional
        self.second_btn = second_btn
        self.second_btn_action_title = second_btn_action_title
        self.out_of_stock_message = out_of_stock_message
        self.pool = pool
        self.pool_initial = pool_initial
        self.wins_count = wins_count
        self.weekdays = weekdays
        self.active_from_ts = active_from_ts
        self.active_till_ts = active_till_ts
        self.relative_period_timezone = relative_period_timezone
        self.is_surcharge = is_surcharge
        self.is_deleted = is_deleted
        self.custom_data = custom_data
        self.prize_modifiers = prize_modifiers
        self.allow_split_decimal = allow_split_decimal
        self.hide_prize_from_history = hide_prize_from_history
        self.requirements_to_get_prize = requirements_to_get_prize
        self.max_give_period_type_id = max_give_period_type_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.prize_type = try c.lenientString("prize_type")
        self.prize_value = try c.lenientDouble("prize_value")
        self.font_size = try c.lenientDouble("font_size")
        self.font_size_mobile = try c.lenientDouble("font_size_mobile")
        self.icon = try c.lenientString("icon")
        self.position = try c.lenientInt64("position")
        self.sectors = try c.lenientList(Double.self, "sectors")
        self.acknowledge_type = try c.lenientString("acknowledge_type")
        self.aknowledge_message = try c.lenientString("aknowledge_message")
        self.aknowledge_message_lose = try c.lenientString("aknowledge_message_lose")
        self.acknowledge_dp = try c.lenientString("acknowledge_dp")
        self.acknowledge_action_title = try c.lenientString("acknowledge_action_title")
        self.acknowledge_dp_additional = try c.lenientString("acknowledge_dp_additional")
        self.acknowledge_action_title_additional = try c.lenientString("acknowledge_action_title_additional")
        self.second_btn = try c.lenientString("second_btn")
        self.second_btn_action_title = try c.lenientString("second_btn_action_title")
        self.out_of_stock_message = try c.lenientString("out_of_stock_message")
        self.pool = try c.lenientDouble("pool")
        self.pool_initial = try c.lenientDouble("pool_initial")
        self.wins_count = try c.lenientInt64("wins_count")
        self.weekdays = try c.lenientList(Int64.self, "weekdays")
        self.active_from_ts = try c.lenientInt64("active_from_ts")
        self.active_till_ts = try c.lenientInt64("active_till_ts")
        self.relative_period_timezone = try c.lenientDouble("relative_period_timezone")
        self.is_surcharge = try c.lenientBool("is_surcharge")
        self.is_deleted = try c.lenientBool("is_deleted")
        self.custom_data = try c.lenientJSON("custom_data")
        self.prize_modifiers = try c.lenientList(String.self, "prize_modifiers")
        self.allow_split_decimal = try c.lenientBool("allow_split_decimal")
        self.hide_prize_from_history = try c.lenientBool("hide_prize_from_history")
        self.requirements_to_get_prize = try c.lenientString("requirements_to_get_prize")
        self.max_give_period_type_id = try c.lenientInt64("max_give_period_type_id")
    }
}
