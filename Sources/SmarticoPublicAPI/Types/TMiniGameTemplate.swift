// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMiniGameTemplate describes the information of mini-games available for the user
public struct TMiniGameTemplate: Codable, Hashable, Sendable {
    /// ID of the mini-game template
    public var id: Int64?
    /// Name of the mini-game template, translated to the user language
    public var name: String?
    /// Description of the mini-game template, translated to the user language
    public var description: String?
    /// URL of the icon of the mini-game template, 256x256px
    public var thumbnail: String?
    /// Indicates if the mini-game is visible when the user have attempts/points/gems/diamonds to play
    public var visibile_when_can_spin: Bool?
    /// The type of the game, e.g. Spin the Wheel, Gift Box, Scratch card, MatchX etc
    public var saw_game_type: String?
    /// How the user is charged for each game attempt e.g. Free, Points or Spin attempts
    public var saw_buyin_type: String?
    /// in case of charging type 'Points', what is the points amount will be deducted from user balance
    public var buyin_cost_points: Int64?
    /// in case of charging type 'Gems', what is the gems amount will be deducted from user balance
    public var buyin_cost_gems: Double?
    /// in case of charging type 'Diamonds', what is the diamonds amount will be deducted from user balance
    public var buyin_cost_diamonds: Double?
    /// in case of charging type 'Spin attempts', shows the current number of spin attempts that user has
    public var spin_count: Int64?
    /// If the game limits the number of attempts per period of time, the epoch-ms time (UTC) when the next attempt becomes available.
    /// Populated only when the operator enabled the "show time to the next available spin" template setting, and only when the
    /// template's maximum attempts per period is 1.
    public var next_available_spin_ts: Int64?
    /// Soonest-expiring spin's expiration time for the current user, as an epoch-ms timestamp.
    /// `null` when the user has no expirable spins for this template — spins only expire when the
    /// template defines a spin-expiration rule (Wheel of Fortune, Loot Boxes, etc.). Pair with
    /// `latest_expiration_dt` to render a "spins expire between X and Y" window.
    public var earliest_expiration_dt: Double?
    /// Latest-expiring spin's expiration time for the current user, as an epoch-ms timestamp.
    /// `null` when the user has no expirable spins; equals `earliest_expiration_dt` when a single
    /// expiration applies.
    public var latest_expiration_dt: Double?
    /// The message that should be shown to the user when he cannot play the game, server rejected attempt with error code SAWSpinErrorCode.SAW_FAILED_MAX_SPINS_REACHED
    public var over_limit_message: String?
    /// The message that should be shown to the user when he cannot play the game because he doesn't have spin attempts or points.
    public var no_attempts_message: String?
    /// Current jackpot amount, if jackpot is enabled.
    public var jackpot_current: Double?
    /// The amount that will be added to the jackpot every time when somebody plays the game. Note that the contribution amount is abstract, means that no money or points are deducted from the user balance.
    public var jackpot_add_on_attempt: Double?
    /// The symbol of jackpot that is giving the sense to the 'amount' E.g. the symbol could be EUR and connected to the amount it can indicate that amount is monetary, e.g. '100 EUR'. Or the symbol can be 'Free spins' and connected to the amount it can indicate that amount is number of free spins, e.g. '100 Free spins'.
    public var jackpot_symbol: String?
    /// The promo image, 500x240px
    public var promo_image: String?
    /// The promo text
    public var promo_text: String?
    /// The custom data of the mini-game defined by operator in the BackOffice. Can be a JSON object, string or number
    public var custom_data: JSON?
    /// Prizes configured for this game — see {@link TMiniGamePrize}
    public var prizes: [TMiniGamePrize]?
    /// Operator template setting. When enabled, the per-prize stock statistics (`pool`, `wins_count`, `weekdays`, `active_from_ts` / `active_till_ts`) are populated on `prizes` and kept current after every play; when disabled (default) those fields are omitted. See `getMiniGames` "Per-prize statistics"
    public var expose_game_stat_on_api: Bool?
    /// Timezone offset in minutes used to evaluate the template's period-based rules (UTC minus local — e.g. `-180` for UTC+3)
    public var relative_period_timezone: Double?
    /// Time from which the template becomes available (epoch ms); absent when not restricted
    public var activeFromDate: Double?
    /// Time until which the template stays available (epoch ms); absent when not restricted
    public var activeTillDate: Double?
    /// Number of steps to complete the game and collect the prize (step games — Voyager / Treasure Hunt)
    public var steps_to_finish_game: Double?
    /// Minimum number of path steps / collectible prizes a session must include before the game can finish (step games — Voyager / Treasure Hunt). `>= 1` and `<= steps_to_finish_game`; when omitted, no minimum is enforced
    public var min_steps_to_finish_game: Double?
    /// ID of the operator-defined custom section (widget menu grouping) the mini-game is assigned to
    public var custom_section_id: Int64?
    /// Full raw UI definition of the mini-game (skin, colors, per-game visual settings) — see {@link SAWTemplateUI}. The commonly needed values are already lifted onto this template object
    public var saw_template_ui_definition: SAWTemplateUI?
    /// Grid layout of the game. Populated only for Lootbox game types (LootboxWeekdays / LootboxCalendarDays)
    public var game_layout: String?
    /// Operator setting: show a prize-history entry point (icon / button) on this game's view
    public var show_prize_history: Bool?
    /// The maximum number of attempts that user can do during period of time
    public var max_number_of_attempts: Double?
    /// The period of time in milliseconds during which the user can do the maximum number of attempts
    public var max_spins_period_ms: Int64?
    /// Which identifier to show next to a win result for transparency/audit — 'userId' (the player's external user id) or 'spinId' (the spin's transaction id). Absent when the operator disabled it
    public var expose_user_spin_id: String?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        thumbnail: String? = nil,
        visibile_when_can_spin: Bool? = nil,
        saw_game_type: String? = nil,
        saw_buyin_type: String? = nil,
        buyin_cost_points: Int64? = nil,
        buyin_cost_gems: Double? = nil,
        buyin_cost_diamonds: Double? = nil,
        spin_count: Int64? = nil,
        next_available_spin_ts: Int64? = nil,
        earliest_expiration_dt: Double? = nil,
        latest_expiration_dt: Double? = nil,
        over_limit_message: String? = nil,
        no_attempts_message: String? = nil,
        jackpot_current: Double? = nil,
        jackpot_add_on_attempt: Double? = nil,
        jackpot_symbol: String? = nil,
        promo_image: String? = nil,
        promo_text: String? = nil,
        custom_data: JSON? = nil,
        prizes: [TMiniGamePrize]? = nil,
        expose_game_stat_on_api: Bool? = nil,
        relative_period_timezone: Double? = nil,
        activeFromDate: Double? = nil,
        activeTillDate: Double? = nil,
        steps_to_finish_game: Double? = nil,
        min_steps_to_finish_game: Double? = nil,
        custom_section_id: Int64? = nil,
        saw_template_ui_definition: SAWTemplateUI? = nil,
        game_layout: String? = nil,
        show_prize_history: Bool? = nil,
        max_number_of_attempts: Double? = nil,
        max_spins_period_ms: Int64? = nil,
        expose_user_spin_id: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.visibile_when_can_spin = visibile_when_can_spin
        self.saw_game_type = saw_game_type
        self.saw_buyin_type = saw_buyin_type
        self.buyin_cost_points = buyin_cost_points
        self.buyin_cost_gems = buyin_cost_gems
        self.buyin_cost_diamonds = buyin_cost_diamonds
        self.spin_count = spin_count
        self.next_available_spin_ts = next_available_spin_ts
        self.earliest_expiration_dt = earliest_expiration_dt
        self.latest_expiration_dt = latest_expiration_dt
        self.over_limit_message = over_limit_message
        self.no_attempts_message = no_attempts_message
        self.jackpot_current = jackpot_current
        self.jackpot_add_on_attempt = jackpot_add_on_attempt
        self.jackpot_symbol = jackpot_symbol
        self.promo_image = promo_image
        self.promo_text = promo_text
        self.custom_data = custom_data
        self.prizes = prizes
        self.expose_game_stat_on_api = expose_game_stat_on_api
        self.relative_period_timezone = relative_period_timezone
        self.activeFromDate = activeFromDate
        self.activeTillDate = activeTillDate
        self.steps_to_finish_game = steps_to_finish_game
        self.min_steps_to_finish_game = min_steps_to_finish_game
        self.custom_section_id = custom_section_id
        self.saw_template_ui_definition = saw_template_ui_definition
        self.game_layout = game_layout
        self.show_prize_history = show_prize_history
        self.max_number_of_attempts = max_number_of_attempts
        self.max_spins_period_ms = max_spins_period_ms
        self.expose_user_spin_id = expose_user_spin_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.thumbnail = try c.lenientString("thumbnail")
        self.visibile_when_can_spin = try c.lenientBool("visibile_when_can_spin")
        self.saw_game_type = try c.lenientString("saw_game_type")
        self.saw_buyin_type = try c.lenientString("saw_buyin_type")
        self.buyin_cost_points = try c.lenientInt64("buyin_cost_points")
        self.buyin_cost_gems = try c.lenientDouble("buyin_cost_gems")
        self.buyin_cost_diamonds = try c.lenientDouble("buyin_cost_diamonds")
        self.spin_count = try c.lenientInt64("spin_count")
        self.next_available_spin_ts = try c.lenientInt64("next_available_spin_ts")
        self.earliest_expiration_dt = try c.lenientDouble("earliest_expiration_dt")
        self.latest_expiration_dt = try c.lenientDouble("latest_expiration_dt")
        self.over_limit_message = try c.lenientString("over_limit_message")
        self.no_attempts_message = try c.lenientString("no_attempts_message")
        self.jackpot_current = try c.lenientDouble("jackpot_current")
        self.jackpot_add_on_attempt = try c.lenientDouble("jackpot_add_on_attempt")
        self.jackpot_symbol = try c.lenientString("jackpot_symbol")
        self.promo_image = try c.lenientString("promo_image")
        self.promo_text = try c.lenientString("promo_text")
        self.custom_data = try c.lenientJSON("custom_data")
        self.prizes = try c.lenientList(TMiniGamePrize.self, "prizes")
        self.expose_game_stat_on_api = try c.lenientBool("expose_game_stat_on_api")
        self.relative_period_timezone = try c.lenientDouble("relative_period_timezone")
        self.activeFromDate = try c.lenientDouble("activeFromDate")
        self.activeTillDate = try c.lenientDouble("activeTillDate")
        self.steps_to_finish_game = try c.lenientDouble("steps_to_finish_game")
        self.min_steps_to_finish_game = try c.lenientDouble("min_steps_to_finish_game")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.saw_template_ui_definition = try c.lenientObject(SAWTemplateUI.self, "saw_template_ui_definition")
        self.game_layout = try c.lenientString("game_layout")
        self.show_prize_history = try c.lenientBool("show_prize_history")
        self.max_number_of_attempts = try c.lenientDouble("max_number_of_attempts")
        self.max_spins_period_ms = try c.lenientInt64("max_spins_period_ms")
        self.expose_user_spin_id = try c.lenientString("expose_user_spin_id")
    }
}
