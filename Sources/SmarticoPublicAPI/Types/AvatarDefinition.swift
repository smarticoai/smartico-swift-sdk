// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AvatarDefinition: Codable, Hashable, Sendable {
    /// Unique identifier of the avatar
    public var avatar_real_id: Int64?
    /// Whether this avatar is the default one
    public var is_default: Bool?
    /// If true, avatar is hidden until user achieves/unlocks it
    public var hide_until_achieved: Bool?
    /// Display priority — lower value means higher position
    public var priority: Int64?
    /// Public metadata containing the avatar image URL and optional description
    public var public_meta: JSON?
    /// Source type of the avatar.
    /// 0 = free (always available), other values = earned/purchased
    public var avatar_source_type_id: Int64?
    /// ISO date string from which the avatar becomes available
    public var active_from_date: String?
    /// ISO date string until which the avatar is available
    public var active_till_date: String?
    /// Whether the avatar has been granted/given to the current user
    public var is_given: Bool?
    /// Whether this avatar is currently in use by the user
    public var is_in_use: Bool?

    public init(
        avatar_real_id: Int64? = nil,
        is_default: Bool? = nil,
        hide_until_achieved: Bool? = nil,
        priority: Int64? = nil,
        public_meta: JSON? = nil,
        avatar_source_type_id: Int64? = nil,
        active_from_date: String? = nil,
        active_till_date: String? = nil,
        is_given: Bool? = nil,
        is_in_use: Bool? = nil
    ) {
        self.avatar_real_id = avatar_real_id
        self.is_default = is_default
        self.hide_until_achieved = hide_until_achieved
        self.priority = priority
        self.public_meta = public_meta
        self.avatar_source_type_id = avatar_source_type_id
        self.active_from_date = active_from_date
        self.active_till_date = active_till_date
        self.is_given = is_given
        self.is_in_use = is_in_use
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.is_default = try c.lenientBool("is_default")
        self.hide_until_achieved = try c.lenientBool("hide_until_achieved")
        self.priority = try c.lenientInt64("priority")
        self.public_meta = try c.lenientJSON("public_meta")
        self.avatar_source_type_id = try c.lenientInt64("avatar_source_type_id")
        self.active_from_date = try c.lenientString("active_from_date")
        self.active_till_date = try c.lenientString("active_till_date")
        self.is_given = try c.lenientBool("is_given")
        self.is_in_use = try c.lenientBool("is_in_use")
    }
}
