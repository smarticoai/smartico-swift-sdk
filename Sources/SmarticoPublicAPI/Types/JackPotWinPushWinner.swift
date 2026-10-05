// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One winner entry inside a {@link JackpotWinPush}.
///
/// Distinct from {@link JackPotWinner}, which is the winner shape returned by the
/// `getJackpotWinners()` history — the live win push carries bet / trigger context
/// and no avatar.
public struct JackPotWinPushWinner: Codable, Hashable, Sendable {
    /// Smartico user ID of the winner
    public var user_id: Int64?
    /// Operator's external user ID of the winner
    public var ext_user_id: String?
    /// Flag indicating that this copy of the push was delivered to the winner themselves
    public var is_me: Bool?
    /// Name of the winner, masked for everyone except `is_me` unless masking is disabled by request to Smartico AM team
    public var public_username: String?
    /// Custom display name; falls back to `public_username` when not set
    public var public_username_custom: String?
    /// Won amount in the Jackpot currency; real and bonus parts are combined
    public var winning_amount_jp_currency: Double?
    /// Won amount in the user Wallet currency; real and bonus parts are combined
    public var winning_amount_wallet_currency: Double?
    /// Position of the winner. Relevant for jackpots where there could be multiple winners
    public var winning_position: Int64?
    /// External game ID of the game whose bet triggered the win; `null` when the triggering bet context is unavailable
    public var winning_game_id: String?
    /// External provider ID of the triggering game's provider; `null` when the triggering bet context is unavailable
    public var winning_provider_id: String?
    /// Placement time of the triggering bet as reported by the operator (epoch milliseconds) — not the time Smartico processed it; `null` when unavailable
    public var bet_original_date: Int64?
    /// Present only on the `is_me` copy; `true` while the win awaits manual approval before payout
    public var pending_approve: Bool?

    public init(
        user_id: Int64? = nil,
        ext_user_id: String? = nil,
        is_me: Bool? = nil,
        public_username: String? = nil,
        public_username_custom: String? = nil,
        winning_amount_jp_currency: Double? = nil,
        winning_amount_wallet_currency: Double? = nil,
        winning_position: Int64? = nil,
        winning_game_id: String? = nil,
        winning_provider_id: String? = nil,
        bet_original_date: Int64? = nil,
        pending_approve: Bool? = nil
    ) {
        self.user_id = user_id
        self.ext_user_id = ext_user_id
        self.is_me = is_me
        self.public_username = public_username
        self.public_username_custom = public_username_custom
        self.winning_amount_jp_currency = winning_amount_jp_currency
        self.winning_amount_wallet_currency = winning_amount_wallet_currency
        self.winning_position = winning_position
        self.winning_game_id = winning_game_id
        self.winning_provider_id = winning_provider_id
        self.bet_original_date = bet_original_date
        self.pending_approve = pending_approve
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.user_id = try c.lenientInt64("user_id")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.is_me = try c.lenientBool("is_me")
        self.public_username = try c.lenientString("public_username")
        self.public_username_custom = try c.lenientString("public_username_custom")
        self.winning_amount_jp_currency = try c.lenientDouble("winning_amount_jp_currency")
        self.winning_amount_wallet_currency = try c.lenientDouble("winning_amount_wallet_currency")
        self.winning_position = try c.lenientInt64("winning_position")
        self.winning_game_id = try c.lenientString("winning_game_id")
        self.winning_provider_id = try c.lenientString("winning_provider_id")
        self.bet_original_date = try c.lenientInt64("bet_original_date")
        self.pending_approve = try c.lenientBool("pending_approve")
    }
}
