// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One jackpot template the user is eligible for, with its live pot snapshot.
/// Returned by `jackpotGet()`.
public struct JackpotDetails: Codable, Hashable, Sendable {
    /// Stable numeric ID of the template; pass to opt-in / opt-out / winners / eligible-games methods.
    public var jp_template_id: Int64?
    /// Whether the jackpot has a shared pot or one independent per user; see {@link JackpotType}.
    public var jp_type_id: Int64?
    /// Display data: name, description, image_url, winner / not-winner HTML templates, custom_data (JSON-parsed).
    public var jp_public_meta: JackpotPublicMeta?
    /// Native jackpot currency (ISO 4217). Used for winner-history amounts.
    public var jp_currency: String?
    /// Current user's wallet currency. Used to display the pot via `pot.current_pot_amount_user_currency`.
    public var user_currency: String?
    /// Whether the contribution is a fixed amount or a percentage of the bet; see {@link JackpotContributionType}.
    public var contribution_type: Int64?
    /// Amount of contribution per qualifying bet — fixed value or percentage depending on `contribution_type`.
    public var contribution_value: Double?
    /// Per-game / per-provider overrides of `contribution_type` + `contribution_value`; see {@link JackpotContributionRule}. Empty when the template contributes at a flat rate.
    public var contribution_rules: [JackpotContributionRule]?
    /// Reserved — the server currently always sends an empty array. Use `getJackpotEligibleGames()` for the eligible-games list.
    public var related_games: [AchRelatedGame]?
    /// Live pot snapshot (amount, temperature, last explosion timestamp).
    public var pot: JackpotPot?
    /// `true` when the current user is currently opted in.
    public var is_opted_in: Bool?
    /// `true` when eligible users are opted in automatically, so no opt-in CTA is needed; `false` means `jackpotOptIn()` must be called explicitly.
    public var is_auto_opt_in: Bool?
    /// `true` when every game in the operator catalog contributes; if `true`, skip `getJackpotEligibleGames`.
    public var ach_related_game_allow_all: Bool?
    /// Number of users currently opted in; always `1` for `JackpotType.Personal`.
    public var registration_count: Int64?
    /// Operator flag: whether the winners list should be displayed. Enforced client-side only — gate `getJackpotWinners` calls on this.
    public var expose_winners_over_api: Bool?

    public init(
        jp_template_id: Int64? = nil,
        jp_type_id: Int64? = nil,
        jp_public_meta: JackpotPublicMeta? = nil,
        jp_currency: String? = nil,
        user_currency: String? = nil,
        contribution_type: Int64? = nil,
        contribution_value: Double? = nil,
        contribution_rules: [JackpotContributionRule]? = nil,
        related_games: [AchRelatedGame]? = nil,
        pot: JackpotPot? = nil,
        is_opted_in: Bool? = nil,
        is_auto_opt_in: Bool? = nil,
        ach_related_game_allow_all: Bool? = nil,
        registration_count: Int64? = nil,
        expose_winners_over_api: Bool? = nil
    ) {
        self.jp_template_id = jp_template_id
        self.jp_type_id = jp_type_id
        self.jp_public_meta = jp_public_meta
        self.jp_currency = jp_currency
        self.user_currency = user_currency
        self.contribution_type = contribution_type
        self.contribution_value = contribution_value
        self.contribution_rules = contribution_rules
        self.related_games = related_games
        self.pot = pot
        self.is_opted_in = is_opted_in
        self.is_auto_opt_in = is_auto_opt_in
        self.ach_related_game_allow_all = ach_related_game_allow_all
        self.registration_count = registration_count
        self.expose_winners_over_api = expose_winners_over_api
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.jp_template_id = try c.lenientInt64("jp_template_id")
        self.jp_type_id = try c.lenientInt64("jp_type_id")
        self.jp_public_meta = try c.lenientObject(JackpotPublicMeta.self, "jp_public_meta")
        self.jp_currency = try c.lenientString("jp_currency")
        self.user_currency = try c.lenientString("user_currency")
        self.contribution_type = try c.lenientInt64("contribution_type")
        self.contribution_value = try c.lenientDouble("contribution_value")
        self.contribution_rules = try c.lenientList(JackpotContributionRule.self, "contribution_rules")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.pot = try c.lenientObject(JackpotPot.self, "pot")
        self.is_opted_in = try c.lenientBool("is_opted_in")
        self.is_auto_opt_in = try c.lenientBool("is_auto_opt_in")
        self.ach_related_game_allow_all = try c.lenientBool("ach_related_game_allow_all")
        self.registration_count = try c.lenientInt64("registration_count")
        self.expose_winners_over_api = try c.lenientBool("expose_winners_over_api")
    }
}
