// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TournamentPlayer: Codable, Hashable, Sendable {
    public var userAltName: String?
    public var cleanExtUserId: String?
    public var crmBrandId: Double?
    public var position: Int64?
    public var scores: Double?
    public var isMe: Bool?
    public var userId: Double?
    public var avatar_id: String?
    public var avatar_url: String?

    public init(
        userAltName: String? = nil,
        cleanExtUserId: String? = nil,
        crmBrandId: Double? = nil,
        position: Int64? = nil,
        scores: Double? = nil,
        isMe: Bool? = nil,
        userId: Double? = nil,
        avatar_id: String? = nil,
        avatar_url: String? = nil
    ) {
        self.userAltName = userAltName
        self.cleanExtUserId = cleanExtUserId
        self.crmBrandId = crmBrandId
        self.position = position
        self.scores = scores
        self.isMe = isMe
        self.userId = userId
        self.avatar_id = avatar_id
        self.avatar_url = avatar_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.userAltName = try c.lenientString("userAltName")
        self.cleanExtUserId = try c.lenientString("cleanExtUserId")
        self.crmBrandId = try c.lenientDouble("crmBrandId")
        self.position = try c.lenientInt64("position")
        self.scores = try c.lenientDouble("scores")
        self.isMe = try c.lenientBool("isMe")
        self.userId = try c.lenientDouble("userId")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_url = try c.lenientString("avatar_url")
    }
}
