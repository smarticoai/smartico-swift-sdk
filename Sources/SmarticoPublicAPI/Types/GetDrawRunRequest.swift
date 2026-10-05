// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetDrawRunRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var raffle_id: Int64?
    public var run_id: Int64?
    public var winners_limit: Double?
    public var winners_offset: Double?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        raffle_id: Int64? = nil,
        run_id: Int64? = nil,
        winners_limit: Double? = nil,
        winners_offset: Double? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.raffle_id = raffle_id
        self.run_id = run_id
        self.winners_limit = winners_limit
        self.winners_offset = winners_offset
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.raffle_id = try c.lenientInt64("raffle_id")
        self.run_id = try c.lenientInt64("run_id")
        self.winners_limit = try c.lenientDouble("winners_limit")
        self.winners_offset = try c.lenientDouble("winners_offset")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
