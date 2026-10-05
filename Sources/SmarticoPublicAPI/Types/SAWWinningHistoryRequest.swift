// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWWinningHistoryRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var limit: Double?
    public var offset: Double?
    public var saw_template_id: Int64?
    public var only_claimed: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        limit: Double? = nil,
        offset: Double? = nil,
        saw_template_id: Int64? = nil,
        only_claimed: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.limit = limit
        self.offset = offset
        self.saw_template_id = saw_template_id
        self.only_claimed = only_claimed
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.limit = try c.lenientDouble("limit")
        self.offset = try c.lenientDouble("offset")
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.only_claimed = try c.lenientBool("only_claimed")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
