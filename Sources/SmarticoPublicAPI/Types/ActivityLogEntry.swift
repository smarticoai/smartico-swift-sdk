// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One raw activity-log row as it arrives on the wire.
///
/// Consumers receive the friendlier {@link TActivityLog} instead — this is the
/// pre-transform shape, documented for native clients that read the protocol directly.
public struct ActivityLogEntry: Codable, Hashable, Sendable {
    /// Creation time; `seconds` is the epoch value in SECONDS (not ms).
    public var create_date: JSON?
    public var user_ext_id: String?
    /// Sent as a string on the wire.
    public var crm_brand_id: String?
    /// Kind of activity this row records.
    public var type: Int64?
    /// Sub-action within `type` (e.g. unlock vs complete, add vs deduct).
    public var ctx_1: Double?
    /// Extra display payload for the row; contents vary by `type`.
    public var ctx_meta: ActivityLogMeta?
    /// What triggered the change.
    public var source_type_id: Int64?
    /// More specific id within the source (e.g. level id, draw id, win id).
    public var source_ref_id: Int64?
    /// Root / parent entity id when the source is nested.
    public var source_root_id: Int64?
    /// Delta applied by this row, in the balance named by `type`.
    public var amount: Double?
    /// Balance after this row, in the balance named by `type`.
    public var balance: Double?
    /// Points balance after this row; points rows only.
    public var user_points_balance: Int64?
    /// Total points ever collected after this row; points rows only.
    public var user_points_ever: Int64?
    /// Placeholder on points rows (`-1`) — read `amount` for the real delta.
    public var points_collected: Int64?

    public init(
        create_date: JSON? = nil,
        user_ext_id: String? = nil,
        crm_brand_id: String? = nil,
        type: Int64? = nil,
        ctx_1: Double? = nil,
        ctx_meta: ActivityLogMeta? = nil,
        source_type_id: Int64? = nil,
        source_ref_id: Int64? = nil,
        source_root_id: Int64? = nil,
        amount: Double? = nil,
        balance: Double? = nil,
        user_points_balance: Int64? = nil,
        user_points_ever: Int64? = nil,
        points_collected: Int64? = nil
    ) {
        self.create_date = create_date
        self.user_ext_id = user_ext_id
        self.crm_brand_id = crm_brand_id
        self.type = type
        self.ctx_1 = ctx_1
        self.ctx_meta = ctx_meta
        self.source_type_id = source_type_id
        self.source_ref_id = source_ref_id
        self.source_root_id = source_root_id
        self.amount = amount
        self.balance = balance
        self.user_points_balance = user_points_balance
        self.user_points_ever = user_points_ever
        self.points_collected = points_collected
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.create_date = try c.lenientJSON("create_date")
        self.user_ext_id = try c.lenientString("user_ext_id")
        self.crm_brand_id = try c.lenientString("crm_brand_id")
        self.type = try c.lenientInt64("type")
        self.ctx_1 = try c.lenientDouble("ctx_1")
        self.ctx_meta = try c.lenientObject(ActivityLogMeta.self, "ctx_meta")
        self.source_type_id = try c.lenientInt64("source_type_id")
        self.source_ref_id = try c.lenientInt64("source_ref_id")
        self.source_root_id = try c.lenientInt64("source_root_id")
        self.amount = try c.lenientDouble("amount")
        self.balance = try c.lenientDouble("balance")
        self.user_points_balance = try c.lenientInt64("user_points_balance")
        self.user_points_ever = try c.lenientInt64("user_points_ever")
        self.points_collected = try c.lenientInt64("points_collected")
    }
}
