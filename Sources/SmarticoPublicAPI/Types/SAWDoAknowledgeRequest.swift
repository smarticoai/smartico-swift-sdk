// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWDoAknowledgeRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var request_id: String?
    /// When true, finalises the spin as lost: the prize is not credited and is returned to the prize pool.
    public var lose: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        request_id: String? = nil,
        lose: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.request_id = request_id
        self.lose = lose
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.request_id = try c.lenientString("request_id")
        self.lose = try c.lenientBool("lose")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
