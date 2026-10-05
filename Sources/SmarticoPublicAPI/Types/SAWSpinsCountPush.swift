// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWSpinsCountPush: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var saw_template_id: Int64?
    public var spin_count: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        saw_template_id: Int64? = nil,
        spin_count: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.saw_template_id = saw_template_id
        self.spin_count = spin_count
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.spin_count = try c.lenientInt64("spin_count")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
