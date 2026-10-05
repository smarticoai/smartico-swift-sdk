// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWDoSpinBatchRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var spins: JSON?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        spins: JSON? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.spins = spins
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.spins = try c.lenientJSON("spins")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
