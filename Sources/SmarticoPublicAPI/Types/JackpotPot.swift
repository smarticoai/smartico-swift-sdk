// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Live snapshot of one jackpot pot's value and temperature.
/// Embedded on `JackpotDetails.pot`; refreshed at the 1 s SDK cache TTL.
public struct JackpotPot: Codable, Hashable, Sendable {
    /// Template ID this pot belongs to.
    public var jp_template_id: Int64?
    /// Stable numeric ID of the current pot instance (rotates when the pot explodes).
    public var jp_pot_id: Int64?
    /// Current pot amount in the jackpot's native currency (`jp_currency`).
    public var current_pot_amount: Double?
    /// Current pot amount converted to the user's wallet currency (`user_currency`).
    public var current_pot_amount_user_currency: Double?
    /// Unix ms timestamp of when this pot last exploded; `null` while the pot is still running.
    public var explode_date_ts: Int64?
    /// Owning user for `JackpotType.Personal` pots; `null` for shared `MultiUser` pots.
    public var user_id: Int64?
    /// Heat band of the pot relative to its explosion range; see {@link JackPotTemparature}.
    public var current_pot_temperature: Int64?

    public init(
        jp_template_id: Int64? = nil,
        jp_pot_id: Int64? = nil,
        current_pot_amount: Double? = nil,
        current_pot_amount_user_currency: Double? = nil,
        explode_date_ts: Int64? = nil,
        user_id: Int64? = nil,
        current_pot_temperature: Int64? = nil
    ) {
        self.jp_template_id = jp_template_id
        self.jp_pot_id = jp_pot_id
        self.current_pot_amount = current_pot_amount
        self.current_pot_amount_user_currency = current_pot_amount_user_currency
        self.explode_date_ts = explode_date_ts
        self.user_id = user_id
        self.current_pot_temperature = current_pot_temperature
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.jp_template_id = try c.lenientInt64("jp_template_id")
        self.jp_pot_id = try c.lenientInt64("jp_pot_id")
        self.current_pot_amount = try c.lenientDouble("current_pot_amount")
        self.current_pot_amount_user_currency = try c.lenientDouble("current_pot_amount_user_currency")
        self.explode_date_ts = try c.lenientInt64("explode_date_ts")
        self.user_id = try c.lenientInt64("user_id")
        self.current_pot_temperature = try c.lenientInt64("current_pot_temperature")
    }
}
