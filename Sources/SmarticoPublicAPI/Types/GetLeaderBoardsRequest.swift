// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetLeaderBoardsRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var period_type_id: Int64?
    public var snapshot_offset: Double?
    public var include_users: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        period_type_id: Int64? = nil,
        snapshot_offset: Double? = nil,
        include_users: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.period_type_id = period_type_id
        self.snapshot_offset = snapshot_offset
        self.include_users = include_users
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.period_type_id = try c.lenientInt64("period_type_id")
        self.snapshot_offset = try c.lenientDouble("snapshot_offset")
        self.include_users = try c.lenientBool("include_users")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
