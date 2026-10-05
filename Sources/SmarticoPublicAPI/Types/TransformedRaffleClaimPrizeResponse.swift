// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TransformedRaffleClaimPrizeResponse describes the response of
/// `Smartico.api.claimRafflePrize({won_id})`.
///
/// Note: this type uses `errorCode` / `errorMessage` (camelCase
/// full-word) — different from most other SDK wrapper-result types in
/// this library which use `err_code` / `err_message` (snake_case).
/// Result of `Smartico.api.claimRafflePrize({raffle_id, draw_id, raffle_run_id})`.
/// Uses camelCase `errorCode` / `errorMessage` — distinct from most other SDK
/// result wrappers which use snake_case `err_code` / `err_message`.
public struct TransformedRaffleClaimPrizeResponse: Codable, Hashable, Sendable {
    /// Error code. `0` = success. See `claimRafflePrize` TSDoc for the full table.
    public var errorCode: Double?
    /// Optional error message; populated on non-zero `errorCode`.
    public var errorMessage: String?

    public init(
        errorCode: Double? = nil,
        errorMessage: String? = nil
    ) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.errorCode = try c.lenientDouble("errorCode")
        self.errorMessage = try c.lenientString("errorMessage")
    }
}
