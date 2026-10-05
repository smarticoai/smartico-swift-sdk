// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMiniGamePlayBatchResult describes one entry in the array returned
/// by `Smartico.api.playMiniGameBatch(template_id, spin_count)`.
///
/// Note: this type uses `errCode` / `errMessage` (camelCase) —
/// different from `TMiniGamePlayResult` which uses `err_code` /
/// `err_message` (snake_case).
public struct TMiniGamePlayBatchResult: Codable, Hashable, Sendable {
    /// ID of the won prize for this spin. Look up in `template.prizes`.
    public var saw_prize_id: Int64?
    /// Error code. `0` = success. See `playMiniGameBatch` TSDoc for the
    /// full table.
    public var errCode: Int64?
    /// Optional server-side error message.
    public var errMessage: String?
    /// Jackpot amount the user won, populated when the prize type is
    /// `'jackpot'`.
    public var jackpot_amount: Double?
    /// Epoch ms of the user's first spin in the current cooldown
    /// period; populated when `errCode === SAWSpinErrorCode.SAW_FAILED_MAX_SPINS_REACHED`.
    public var first_spin_in_period: Double?

    public init(
        saw_prize_id: Int64? = nil,
        errCode: Int64? = nil,
        errMessage: String? = nil,
        jackpot_amount: Double? = nil,
        first_spin_in_period: Double? = nil
    ) {
        self.saw_prize_id = saw_prize_id
        self.errCode = errCode
        self.errMessage = errMessage
        self.jackpot_amount = jackpot_amount
        self.first_spin_in_period = first_spin_in_period
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.saw_prize_id = try c.lenientInt64("saw_prize_id")
        self.errCode = try c.lenientInt64("errCode")
        self.errMessage = try c.lenientString("errMessage")
        self.jackpot_amount = try c.lenientDouble("jackpot_amount")
        self.first_spin_in_period = try c.lenientDouble("first_spin_in_period")
    }
}
