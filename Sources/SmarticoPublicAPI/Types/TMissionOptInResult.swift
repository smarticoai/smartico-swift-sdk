// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Response of `Smartico.api.requestMissionOptIn(mission_id)`.
///
/// See `requestMissionOptIn` TSDoc for the full table of `err_code` values
/// and recommended UI handling.
public struct TMissionOptInResult: Codable, Hashable, Sendable {
    /// Error code. `0` = success. See `requestMissionOptIn` TSDoc for the full table.
    public var err_code: Int64?
    /// Optional error message; populated on non-zero `err_code`.
    public var err_message: String?

    public init(
        err_code: Int64? = nil,
        err_message: String? = nil
    ) {
        self.err_code = err_code
        self.err_message = err_message
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.err_code = try c.lenientInt64("err_code")
        self.err_message = try c.lenientString("err_message")
    }
}
