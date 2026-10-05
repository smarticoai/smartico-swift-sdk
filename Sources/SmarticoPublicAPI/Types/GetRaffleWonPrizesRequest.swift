// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetRaffleWonPrizesRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    /// ID of the raffle to fetch the current user's won prizes for.
    public var raffle_id: Int64?
    /// Zero-based index of the first won-prize row to return (pagination).
    public var offset: Double?
    /// Maximum number of won-prize rows to return (pagination).
    public var limit: Double?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        raffle_id: Int64? = nil,
        offset: Double? = nil,
        limit: Double? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.raffle_id = raffle_id
        self.offset = offset
        self.limit = limit
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.raffle_id = try c.lenientInt64("raffle_id")
        self.offset = try c.lenientDouble("offset")
        self.limit = try c.lenientDouble("limit")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
