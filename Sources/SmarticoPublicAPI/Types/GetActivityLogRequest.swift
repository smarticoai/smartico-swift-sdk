// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetActivityLogRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var userId: Double?
    public var startTimeSeconds: Int64?
    public var endTimeSeconds: Int64?
    public var limit: Double?
    public var offset: Double?
    /// Optional filter — {@link ActivityLogActivities} values to include.
    public var types: [Double]?
    /// Optional filter — {@link PointChangeSourceType} values to include.
    public var src_types: [Double]?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        userId: Double? = nil,
        startTimeSeconds: Int64? = nil,
        endTimeSeconds: Int64? = nil,
        limit: Double? = nil,
        offset: Double? = nil,
        types: [Double]? = nil,
        src_types: [Double]? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.userId = userId
        self.startTimeSeconds = startTimeSeconds
        self.endTimeSeconds = endTimeSeconds
        self.limit = limit
        self.offset = offset
        self.types = types
        self.src_types = src_types
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.userId = try c.lenientDouble("userId")
        self.startTimeSeconds = try c.lenientInt64("startTimeSeconds")
        self.endTimeSeconds = try c.lenientInt64("endTimeSeconds")
        self.limit = try c.lenientDouble("limit")
        self.offset = try c.lenientDouble("offset")
        self.types = try c.lenientList(Double.self, "types")
        self.src_types = try c.lenientList(Double.self, "src_types")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
