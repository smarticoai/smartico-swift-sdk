// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GResponseBase: Codable, Hashable, Sendable {
    public var errCode: ErrorCodes?
    public var errMessage: String?

    public init(
        errCode: ErrorCodes? = nil,
        errMessage: String? = nil
    ) {
        self.errCode = errCode
        self.errMessage = errMessage
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.errCode = try c.lenientInt64("errCode")
        self.errMessage = try c.lenientString("errMessage")
    }
}
