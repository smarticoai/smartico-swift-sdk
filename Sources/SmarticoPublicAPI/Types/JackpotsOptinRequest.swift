// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotsOptinRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var jp_template_id: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        jp_template_id: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.jp_template_id = jp_template_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.jp_template_id = try c.lenientInt64("jp_template_id")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
