// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TClaimBonusResult describes the response of `Smartico.api.claimBonus(bonus_id)`.
/// Result of `Smartico.api.claimBonus(bonus_id)`.
public struct TClaimBonusResult: Codable, Hashable, Sendable {
    /// Error code. `0` = success. See `claimBonus` TSDoc for the full table.
    public var err_code: Int64?
    /// Optional error message; populated on non-zero `err_code`.
    public var err_message: String?
    /// Unreliable on the wire — prefer `err_code === 0` as the success check.
    public var success: Bool?

    public init(
        err_code: Int64? = nil,
        err_message: String? = nil,
        success: Bool? = nil
    ) {
        self.err_code = err_code
        self.err_message = err_message
        self.success = success
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.err_code = try c.lenientInt64("err_code")
        self.err_message = try c.lenientString("err_message")
        self.success = try c.lenientBool("success")
    }
}
