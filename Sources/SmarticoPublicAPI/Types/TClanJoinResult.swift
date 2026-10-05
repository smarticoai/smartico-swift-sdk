// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TClanJoinResult describes the result of a join-clan request.
/// Note: this type uses `errCode` / `errMsg` (camelCase) — different
/// from most other SDK result types in this library which use
/// `err_code` / `err_message` (snake_case).
public struct TClanJoinResult: Codable, Hashable, Sendable {
    /// Error code. `0` = success. Typed values are members of
    /// {@link JoinClanErrorCode}. See `joinClan` TSDoc for the full
    /// table and per-code UI guidance.
    public var errCode: Int64?
    /// Optional server-side error message. Present only on non-zero
    /// `errCode`; may be empty even then.
    public var errMsg: String?

    public init(
        errCode: Int64? = nil,
        errMsg: String? = nil
    ) {
        self.errCode = errCode
        self.errMsg = errMsg
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
    }
}
