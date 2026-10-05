// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamesApiResponse is the standard response wrapper for all GamePick/Quiz API calls
public struct GamesApiResponse: Codable, Hashable, Sendable {
    /// Error code; `0` = success. Per-method code tables live in each `gamePick*` method's TSDoc.
    public var errCode: Int64?
    /// Human-readable error message; populated when `errCode` is non-zero.
    public var errMessage: String?
    /// Response payload, present on success
    public var data: JSON?

    public init(
        errCode: Int64? = nil,
        errMessage: String? = nil,
        data: JSON? = nil
    ) {
        self.errCode = errCode
        self.errMessage = errMessage
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.errCode = try c.lenientInt64("errCode")
        self.errMessage = try c.lenientString("errMessage")
        self.data = try c.lenientJSON("data")
    }
}
