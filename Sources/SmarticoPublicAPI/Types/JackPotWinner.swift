// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackPotWinner: Codable, Hashable, Sendable {
    /// Flag indicating that this winner is the currently logged in user
    public var is_me: Bool?
    /// Name of the winner, note that for all users except is_me, the name is masked by default, but masking can be disabled by request to Smartico AM team
    public var public_username: String?
    /// Won amount in the Jackpot currency
    public var winning_amount_jp_currency: Double?
    /// Won amount in the user Wallet currency
    public var winning_amount_wallet_currency: Double?
    /// Position of the winner. Relevant for jackpots where there could be multiple winners
    public var winning_position: Int64?
    /// Avatar image URL of the winner
    public var avatar_id: String?
    /// Numeric ID of the winner's avatar; `null` when the winner has not picked one
    public var avatar_real_id: Int64?

    public init(
        is_me: Bool? = nil,
        public_username: String? = nil,
        winning_amount_jp_currency: Double? = nil,
        winning_amount_wallet_currency: Double? = nil,
        winning_position: Int64? = nil,
        avatar_id: String? = nil,
        avatar_real_id: Int64? = nil
    ) {
        self.is_me = is_me
        self.public_username = public_username
        self.winning_amount_jp_currency = winning_amount_jp_currency
        self.winning_amount_wallet_currency = winning_amount_wallet_currency
        self.winning_position = winning_position
        self.avatar_id = avatar_id
        self.avatar_real_id = avatar_real_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.is_me = try c.lenientBool("is_me")
        self.public_username = try c.lenientString("public_username")
        self.winning_amount_jp_currency = try c.lenientDouble("winning_amount_jp_currency")
        self.winning_amount_wallet_currency = try c.lenientDouble("winning_amount_wallet_currency")
        self.winning_position = try c.lenientInt64("winning_position")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
    }
}
