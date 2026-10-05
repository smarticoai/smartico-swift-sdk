// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One avatar in the user's catalog. Returned by `getAvatarsList()`.
/// Fields from the raw `public_meta` object are flattened to the top level.
public struct TAvatarDefinition: Codable, Hashable, Sendable {
    /// Stable numeric identifier of the avatar. Primary key passed to `setAvatar()`.
    public var avatar_real_id: Int64?
    /// True when this is the system default avatar for the label.
    public var is_default: Bool?
    /// When true and `is_given === false`, the avatar should be hidden from the user (surprise unlock).
    public var hide_until_achieved: Bool?
    /// Display position; lower = earlier in the grid.
    public var priority: Int64?
    /// Optional description shown alongside the avatar in detail views.
    public var description: String?
    /// Raw image path as returned by the server (relative or absolute).
    public var url: String?
    /// Absolute CDN URL of the avatar image; built from the configured avatar domain + `url`.
    public var avatar_url: String?
    /// Source type. `0` = free / always available; non-zero = earned or purchased.
    public var avatar_source_type_id: Int64?
    /// ISO date string from which the avatar becomes available; undefined when no start window.
    public var active_from_date: String?
    /// ISO date string until which the avatar is available; undefined when no end window.
    public var active_till_date: String?
    /// True when the user owns / has unlocked this avatar.
    public var is_given: Bool?
    /// True when this avatar is the user's currently active profile avatar.
    public var is_in_use: Bool?

    public init(
        avatar_real_id: Int64? = nil,
        is_default: Bool? = nil,
        hide_until_achieved: Bool? = nil,
        priority: Int64? = nil,
        description: String? = nil,
        url: String? = nil,
        avatar_url: String? = nil,
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
        self.description = description
        self.url = url
        self.avatar_url = avatar_url
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
        self.description = try c.lenientString("description")
        self.url = try c.lenientString("url")
        self.avatar_url = try c.lenientString("avatar_url")
        self.avatar_source_type_id = try c.lenientInt64("avatar_source_type_id")
        self.active_from_date = try c.lenientString("active_from_date")
        self.active_till_date = try c.lenientString("active_till_date")
        self.is_given = try c.lenientBool("is_given")
        self.is_in_use = try c.lenientBool("is_in_use")
    }
}
