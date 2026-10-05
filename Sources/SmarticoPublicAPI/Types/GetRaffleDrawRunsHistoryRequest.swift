// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetRaffleDrawRunsHistoryRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var raffle_id: Int64?
    /// If draw_id is not passed all draw runs that belong to raffle with passed raffle_id will be returned.
    public var draw_id: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        raffle_id: Int64? = nil,
        draw_id: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.raffle_id = raffle_id
        self.draw_id = draw_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.raffle_id = try c.lenientInt64("raffle_id")
        self.draw_id = try c.lenientInt64("draw_id")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
