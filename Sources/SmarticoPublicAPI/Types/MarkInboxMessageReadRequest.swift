// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct MarkInboxMessageReadRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var engagement_uid: String?
    public var all_read: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        engagement_uid: String? = nil,
        all_read: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.engagement_uid = engagement_uid
        self.all_read = all_read
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.engagement_uid = try c.lenientString("engagement_uid")
        self.all_read = try c.lenientBool("all_read")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
