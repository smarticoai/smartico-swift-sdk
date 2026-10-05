// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanMember: Codable, Hashable, Sendable {
    public var user_id: Int64?
    public var public_username: String?
    public var avatar_id: String?
    public var avatar_real_id: Int64?
    /// Rank within clan
    public var position: Int64?
    /// Aggregated tournament contribution
    public var contribution_score: Double?
    public var is_me: Bool?
    public var clean_ext_user_id: String?

    public init(
        user_id: Int64? = nil,
        public_username: String? = nil,
        avatar_id: String? = nil,
        avatar_real_id: Int64? = nil,
        position: Int64? = nil,
        contribution_score: Double? = nil,
        is_me: Bool? = nil,
        clean_ext_user_id: String? = nil
    ) {
        self.user_id = user_id
        self.public_username = public_username
        self.avatar_id = avatar_id
        self.avatar_real_id = avatar_real_id
        self.position = position
        self.contribution_score = contribution_score
        self.is_me = is_me
        self.clean_ext_user_id = clean_ext_user_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.user_id = try c.lenientInt64("user_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.position = try c.lenientInt64("position")
        self.contribution_score = try c.lenientDouble("contribution_score")
        self.is_me = try c.lenientBool("is_me")
        self.clean_ext_user_id = try c.lenientString("clean_ext_user_id")
    }
}
