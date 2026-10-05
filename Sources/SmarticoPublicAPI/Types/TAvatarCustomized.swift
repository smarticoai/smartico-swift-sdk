// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One AI-generated variant of a base avatar. Returned by `getAvatarsCustomized()`.
public struct TAvatarCustomized: Codable, Hashable, Sendable {
    /// `avatar_real_id` of the base avatar this variant was generated from.
    public var avatar_real_id: Int64?
    /// Absolute CDN URL of the AI-generated image. Can be passed as `avatar_url` to `setAvatar()`.
    public var url: String?
    /// Unix-ms timestamp of when the variant was generated.
    public var dt_created: Int64?

    public init(
        avatar_real_id: Int64? = nil,
        url: String? = nil,
        dt_created: Int64? = nil
    ) {
        self.avatar_real_id = avatar_real_id
        self.url = url
        self.dt_created = dt_created
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.url = try c.lenientString("url")
        self.dt_created = try c.lenientInt64("dt_created")
    }
}
