// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Result of `Smartico.api.avatarsCustomize()`. On success only `cdn_url` is
/// set; on failure only `errCode` / `errMessage`.
public struct AvatarCustomizeResponse: Codable, Hashable, Sendable {
    /// CDN URL of the generated avatar variant. Present on success.
    public var cdn_url: String?
    /// Error code. Present on failure. Typed values are members of
    /// {@link AvatarCustomizeErrorCode}; `-1` is a generic failure. See the
    /// `avatarsCustomize` TSDoc for the full table.
    public var errCode: JSON?
    /// Optional error message. Present on failure; the generic (`-1`) message
    /// is fixed text, so branch on `errCode`, not this string.
    public var errMessage: String?

    public init(
        cdn_url: String? = nil,
        errCode: JSON? = nil,
        errMessage: String? = nil
    ) {
        self.cdn_url = cdn_url
        self.errCode = errCode
        self.errMessage = errMessage
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cdn_url = try c.lenientString("cdn_url")
        self.errCode = try c.lenientJSON("errCode")
        self.errMessage = try c.lenientString("errMessage")
    }
}
