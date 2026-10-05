// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GResponse: Codable, Hashable, Sendable {
    public var errCode: ErrorCodes?
    public var errMessage: String?
    public var data: JSON?

    public init(
        errCode: ErrorCodes? = nil,
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
// Inherited fields from GResponseBase are flattened above.
