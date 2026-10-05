// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct MarkInboxMessageStarredRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var engagement_uid: String?
    public var is_starred: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        engagement_uid: String? = nil,
        is_starred: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.engagement_uid = engagement_uid
        self.is_starred = is_starred
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.engagement_uid = try c.lenientString("engagement_uid")
        self.is_starred = try c.lenientBool("is_starred")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
