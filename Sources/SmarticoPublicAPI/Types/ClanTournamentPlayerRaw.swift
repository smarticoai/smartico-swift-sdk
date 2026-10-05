// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanTournamentPlayerRaw: Codable, Hashable, Sendable {
    public var userId: Double?
    public var cleanExtUserId: String?
    public var userAltName: String?
    public var avatar_id: String?
    public var avatar_real_id: Int64?
    public var position: Int64?
    public var scores: Double?
    public var isMe: Bool?
    public var registration_status: Int64?
    public var crmBrandId: Double?
    public var avatar_url: String?

    public init(
        userId: Double? = nil,
        cleanExtUserId: String? = nil,
        userAltName: String? = nil,
        avatar_id: String? = nil,
        avatar_real_id: Int64? = nil,
        position: Int64? = nil,
        scores: Double? = nil,
        isMe: Bool? = nil,
        registration_status: Int64? = nil,
        crmBrandId: Double? = nil,
        avatar_url: String? = nil
    ) {
        self.userId = userId
        self.cleanExtUserId = cleanExtUserId
        self.userAltName = userAltName
        self.avatar_id = avatar_id
        self.avatar_real_id = avatar_real_id
        self.position = position
        self.scores = scores
        self.isMe = isMe
        self.registration_status = registration_status
        self.crmBrandId = crmBrandId
        self.avatar_url = avatar_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.userId = try c.lenientDouble("userId")
        self.cleanExtUserId = try c.lenientString("cleanExtUserId")
        self.userAltName = try c.lenientString("userAltName")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.position = try c.lenientInt64("position")
        self.scores = try c.lenientDouble("scores")
        self.isMe = try c.lenientBool("isMe")
        self.registration_status = try c.lenientInt64("registration_status")
        self.crmBrandId = try c.lenientDouble("crmBrandId")
        self.avatar_url = try c.lenientString("avatar_url")
    }
}
