// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWTemplate: Codable, Hashable, Sendable {
    /// ID of the mini-game template
    public var saw_template_id: Int64?
    /// The type of the game — see {@link SAWGameType}
    public var saw_game_type_id: Int64?
    /// Full UI definition of the mini-game (name, description, skin, colors, per-game visual settings)
    public var saw_template_ui_definition: SAWTemplateUI?
    /// How the user is charged per attempt — see {@link SAWBuyInType}
    public var saw_buyin_type_id: Int64?
    /// Cost per attempt in the buy-in currency (points, gems or diamonds per `saw_buyin_type_id`)
    public var buyin_cost_points: Int64?
    /// Operator hint: show the game only while the user can actually play it (has attempts / sufficient balance)
    public var visibile_when_can_spin: Bool?
    /// Number of spin attempts the user currently has (initial value; later changes arrive as spin-count pushes)
    public var spin_count: Int64?
    /// Prizes configured for this game — see {@link SAWPrize}
    public var prizes: [SAWPrize]?
    /// Operator visibility flag for the template
    public var is_visible: Bool?
    /// Time from which the template becomes available (epoch ms); absent when not restricted
    public var activeFromDate: Double?
    /// Time until which the template stays available (epoch ms); absent when not restricted
    public var activeTillDate: Double?
    /// Amount added to the jackpot on every play (abstract contribution — nothing is deducted from the player)
    public var jackpot_add_on_attempt: Double?
    /// Current jackpot accumulator value
    public var jackpot_current: Double?
    /// Seed value of the jackpot — the accumulator starts at (and resets to) this amount after a jackpot win
    public var jackpot_guaranteed: Double?
    /// Maximum number of unspent spin attempts a user can accumulate
    public var maxActiveSpinsAllowed: Double?
    /// Maximum number of attempts a user can make during `maxSpinsPediodMs`
    public var maxSpinsCount: Int64?
    /// Length of the attempt-limit period in ms (note the field-name spelling)
    public var maxSpinsPediodMs: Double?
    /// Epoch-ms time when the next attempt becomes available; populated only when the operator enabled the "show time to the next available spin" setting and max attempts per period is 1
    public var next_available_spin_ts: Int64?
    /// Soonest-expiring spin's expiration time for this user (epoch ms); `null`/absent when no expirable spins.
    public var earliest_expiration_dt: Double?
    /// Latest-expiring spin's expiration time for this user (epoch ms); `null`/absent when no expirable spins.
    public var latest_expiration_dt: Double?
    /// Key of the visual skin the operator selected for the game
    public var saw_skin_key: String?
    /// Skin assets of the game: `skin_folder` is the base URL for the skin's images, `skin_css` custom CSS overrides, plus optional popup/animation tweaks
    public var saw_skin_ui_definition: JSON?
    /// Operator template setting. When enabled, the per-prize stock statistics (`pool`, `wins_count`, `weekdays`, `active_from_ts` / `active_till_ts`) are populated on `prizes`; when disabled (default) the server strips them from the response (`pool` is kept for MatchX / Quiz games).
    public var expose_game_stat_on_api: Bool?
    /// Prize Drop only: when true, the pushed prize requires an explicit claim by the user before it is credited
    public var requires_prize_claim: Bool?
    /// Prize Drop only: when true, the pushed prize requires a manual claim by the user before it is credited. The difference between this and `requires_prize_claim` is that requires_manual_claim gives the user the ability to cancel the claim.
    public var requires_manual_claim: Bool?
    /// Timezone offset in minutes used to evaluate the template's period-based rules (UTC minus local)
    public var relative_period_timezone: Double?
    /// Operator setting: show a prize-history entry point (icon / button) on this game's view
    public var show_prize_history: Bool?

    public init(
        saw_template_id: Int64? = nil,
        saw_game_type_id: Int64? = nil,
        saw_template_ui_definition: SAWTemplateUI? = nil,
        saw_buyin_type_id: Int64? = nil,
        buyin_cost_points: Int64? = nil,
        visibile_when_can_spin: Bool? = nil,
        spin_count: Int64? = nil,
        prizes: [SAWPrize]? = nil,
        is_visible: Bool? = nil,
        activeFromDate: Double? = nil,
        activeTillDate: Double? = nil,
        jackpot_add_on_attempt: Double? = nil,
        jackpot_current: Double? = nil,
        jackpot_guaranteed: Double? = nil,
        maxActiveSpinsAllowed: Double? = nil,
        maxSpinsCount: Int64? = nil,
        maxSpinsPediodMs: Double? = nil,
        next_available_spin_ts: Int64? = nil,
        earliest_expiration_dt: Double? = nil,
        latest_expiration_dt: Double? = nil,
        saw_skin_key: String? = nil,
        saw_skin_ui_definition: JSON? = nil,
        expose_game_stat_on_api: Bool? = nil,
        requires_prize_claim: Bool? = nil,
        requires_manual_claim: Bool? = nil,
        relative_period_timezone: Double? = nil,
        show_prize_history: Bool? = nil
    ) {
        self.saw_template_id = saw_template_id
        self.saw_game_type_id = saw_game_type_id
        self.saw_template_ui_definition = saw_template_ui_definition
        self.saw_buyin_type_id = saw_buyin_type_id
        self.buyin_cost_points = buyin_cost_points
        self.visibile_when_can_spin = visibile_when_can_spin
        self.spin_count = spin_count
        self.prizes = prizes
        self.is_visible = is_visible
        self.activeFromDate = activeFromDate
        self.activeTillDate = activeTillDate
        self.jackpot_add_on_attempt = jackpot_add_on_attempt
        self.jackpot_current = jackpot_current
        self.jackpot_guaranteed = jackpot_guaranteed
        self.maxActiveSpinsAllowed = maxActiveSpinsAllowed
        self.maxSpinsCount = maxSpinsCount
        self.maxSpinsPediodMs = maxSpinsPediodMs
        self.next_available_spin_ts = next_available_spin_ts
        self.earliest_expiration_dt = earliest_expiration_dt
        self.latest_expiration_dt = latest_expiration_dt
        self.saw_skin_key = saw_skin_key
        self.saw_skin_ui_definition = saw_skin_ui_definition
        self.expose_game_stat_on_api = expose_game_stat_on_api
        self.requires_prize_claim = requires_prize_claim
        self.requires_manual_claim = requires_manual_claim
        self.relative_period_timezone = relative_period_timezone
        self.show_prize_history = show_prize_history
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.saw_game_type_id = try c.lenientInt64("saw_game_type_id")
        self.saw_template_ui_definition = try c.lenientObject(SAWTemplateUI.self, "saw_template_ui_definition")
        self.saw_buyin_type_id = try c.lenientInt64("saw_buyin_type_id")
        self.buyin_cost_points = try c.lenientInt64("buyin_cost_points")
        self.visibile_when_can_spin = try c.lenientBool("visibile_when_can_spin")
        self.spin_count = try c.lenientInt64("spin_count")
        self.prizes = try c.lenientList(SAWPrize.self, "prizes")
        self.is_visible = try c.lenientBool("is_visible")
        self.activeFromDate = try c.lenientDouble("activeFromDate")
        self.activeTillDate = try c.lenientDouble("activeTillDate")
        self.jackpot_add_on_attempt = try c.lenientDouble("jackpot_add_on_attempt")
        self.jackpot_current = try c.lenientDouble("jackpot_current")
        self.jackpot_guaranteed = try c.lenientDouble("jackpot_guaranteed")
        self.maxActiveSpinsAllowed = try c.lenientDouble("maxActiveSpinsAllowed")
        self.maxSpinsCount = try c.lenientInt64("maxSpinsCount")
        self.maxSpinsPediodMs = try c.lenientDouble("maxSpinsPediodMs")
        self.next_available_spin_ts = try c.lenientInt64("next_available_spin_ts")
        self.earliest_expiration_dt = try c.lenientDouble("earliest_expiration_dt")
        self.latest_expiration_dt = try c.lenientDouble("latest_expiration_dt")
        self.saw_skin_key = try c.lenientString("saw_skin_key")
        self.saw_skin_ui_definition = try c.lenientJSON("saw_skin_ui_definition")
        self.expose_game_stat_on_api = try c.lenientBool("expose_game_stat_on_api")
        self.requires_prize_claim = try c.lenientBool("requires_prize_claim")
        self.requires_manual_claim = try c.lenientBool("requires_manual_claim")
        self.relative_period_timezone = try c.lenientDouble("relative_period_timezone")
        self.show_prize_history = try c.lenientBool("show_prize_history")
    }
}
