// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetInboxMessagesRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var limit: Double?
    public var offset: Double?
    public var starred_only: Bool?
    public var category_id: Int64?
    public var read_status: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        limit: Double? = nil,
        offset: Double? = nil,
        starred_only: Bool? = nil,
        category_id: Int64? = nil,
        read_status: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.limit = limit
        self.offset = offset
        self.starred_only = starred_only
        self.category_id = category_id
        self.read_status = read_status
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.limit = try c.lenientDouble("limit")
        self.offset = try c.lenientDouble("offset")
        self.starred_only = try c.lenientBool("starred_only")
        self.category_id = try c.lenientInt64("category_id")
        self.read_status = try c.lenientInt64("read_status")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
