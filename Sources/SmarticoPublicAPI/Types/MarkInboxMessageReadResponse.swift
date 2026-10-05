// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct MarkInboxMessageReadResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
