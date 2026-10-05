// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TTournamentPlayer — generated from the anonymous object literal the public API
/// declares inline; the fields are exactly the ones declared there.
public struct TTournamentPlayer: Codable, Hashable, Sendable {
    /// The username of the participant
    public var public_username: String?
    /// The URL to the avatar of the participant
    public var avatar_url: String?
    /// The position of the participant in the tournament
    public var position: Int64?
    /// The scores of the participant in the tournament
    public var scores: Double?
    /// The indicator if the participant is current user
    public var is_me: Bool?
    /// The external user id of the participant
    public var user_ext_id: String?
    /// The crm brand id of the participant
    public var crm_brand_id: Int64?
    /// The user id of the participant
    public var user_id: Int64?

    public init(
        public_username: String? = nil,
        avatar_url: String? = nil,
        position: Int64? = nil,
        scores: Double? = nil,
        is_me: Bool? = nil,
        user_ext_id: String? = nil,
        crm_brand_id: Int64? = nil,
        user_id: Int64? = nil
    ) {
        self.public_username = public_username
        self.avatar_url = avatar_url
        self.position = position
        self.scores = scores
        self.is_me = is_me
        self.user_ext_id = user_ext_id
        self.crm_brand_id = crm_brand_id
        self.user_id = user_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.public_username = try c.lenientString("public_username")
        self.avatar_url = try c.lenientString("avatar_url")
        self.position = try c.lenientInt64("position")
        self.scores = try c.lenientDouble("scores")
        self.is_me = try c.lenientBool("is_me")
        self.user_ext_id = try c.lenientString("user_ext_id")
        self.crm_brand_id = try c.lenientInt64("crm_brand_id")
        self.user_id = try c.lenientInt64("user_id")
    }
}
