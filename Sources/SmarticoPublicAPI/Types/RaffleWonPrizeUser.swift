// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// The user the won-prizes list belongs to.
public struct RaffleWonPrizeUser: Codable, Hashable, Sendable {
    /// Internal user ID.
    public var user_id: Int64?
    /// Avatar image: a full URL for a system avatar, otherwise an avatar token to resolve against the widget's avatar domain.
    public var avatar_id: String?
    /// Numeric ID of the user's selected avatar definition.
    public var avatar_real_id: Int64?
    /// Public username; server-masked for other users (e.g. `"32:r*****"`).
    public var public_username: String?
    /// Always `null` on the wire — use `avatar_id`.
    public var avatar_url: String?

    public init(
        user_id: Int64? = nil,
        avatar_id: String? = nil,
        avatar_real_id: Int64? = nil,
        public_username: String? = nil,
        avatar_url: String? = nil
    ) {
        self.user_id = user_id
        self.avatar_id = avatar_id
        self.avatar_real_id = avatar_real_id
        self.public_username = public_username
        self.avatar_url = avatar_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.user_id = try c.lenientInt64("user_id")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_url = try c.lenientString("avatar_url")
    }
}
