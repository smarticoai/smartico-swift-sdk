// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One activity-log row from {@link WSAPIUser.getActivityLog}.
///
/// Always includes the wallet fields (`type` / `amount` / `balance` / …). When the
/// server returns richer activity rows (missions, badges, levels, …), the optional
/// fields below are populated — same method, same CID; clients that ignore unknown
/// fields keep working.
public struct TActivityLog: Codable, Hashable, Sendable {
    /// Date when the change was created (epoch timestamp in seconds)
    public var create_date: Int64?
    /// External user ID
    public var user_ext_id: String?
    /// CRM brand ID
    public var crm_brand_id: Int64?
    /// Type of balance: Points = 0, Gems = 1, Diamonds = 2
    public var type: Int64?
    /// Amount changed (positive or negative)
    public var amount: Double?
    /// Current balance after this change
    public var balance: Double?
    /// Total ever collected (only relevant for type points)
    public var total_ever: Double?
    /// Source type ID indicating what triggered this change
    public var source_type_id: Int64?
    /// Activity kind — see {@link ActivityLogActivities} (`type` on the wire).
    public var activity_type_id: Int64?
    /// Sub-action for `activity_type_id` (e.g. unlock vs complete, add vs deduct, raffle win vs register).
    public var context_value_1: Double?
    /// Extra display payload for the row (name, image, position, …) — see {@link ActivityLogMeta}.
    public var meta: ActivityLogMeta?
    /// Human-readable name of the source entity (mission, tournament, raffle, …).
    public var source_entity_name: String?
    /// Primary id of the source entity (mission / badge / tournament / …).
    public var source_entity_id: Int64?
    /// More specific id within the source (e.g. level id, draw id, win id).
    public var source_reference_id: Int64?
    /// Root / parent entity id when the source is nested (e.g. raffle id owning a draw).
    public var source_root_id: Int64?
    /// True when the row is a points/gems/diamonds wallet change.
    public var is_wallet_entry: Bool?

    public init(
        create_date: Int64? = nil,
        user_ext_id: String? = nil,
        crm_brand_id: Int64? = nil,
        type: Int64? = nil,
        amount: Double? = nil,
        balance: Double? = nil,
        total_ever: Double? = nil,
        source_type_id: Int64? = nil,
        activity_type_id: Int64? = nil,
        context_value_1: Double? = nil,
        meta: ActivityLogMeta? = nil,
        source_entity_name: String? = nil,
        source_entity_id: Int64? = nil,
        source_reference_id: Int64? = nil,
        source_root_id: Int64? = nil,
        is_wallet_entry: Bool? = nil
    ) {
        self.create_date = create_date
        self.user_ext_id = user_ext_id
        self.crm_brand_id = crm_brand_id
        self.type = type
        self.amount = amount
        self.balance = balance
        self.total_ever = total_ever
        self.source_type_id = source_type_id
        self.activity_type_id = activity_type_id
        self.context_value_1 = context_value_1
        self.meta = meta
        self.source_entity_name = source_entity_name
        self.source_entity_id = source_entity_id
        self.source_reference_id = source_reference_id
        self.source_root_id = source_root_id
        self.is_wallet_entry = is_wallet_entry
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.create_date = try c.lenientInt64("create_date")
        self.user_ext_id = try c.lenientString("user_ext_id")
        self.crm_brand_id = try c.lenientInt64("crm_brand_id")
        self.type = try c.lenientInt64("type")
        self.amount = try c.lenientDouble("amount")
        self.balance = try c.lenientDouble("balance")
        self.total_ever = try c.lenientDouble("total_ever")
        self.source_type_id = try c.lenientInt64("source_type_id")
        self.activity_type_id = try c.lenientInt64("activity_type_id")
        self.context_value_1 = try c.lenientDouble("context_value_1")
        self.meta = try c.lenientObject(ActivityLogMeta.self, "meta")
        self.source_entity_name = try c.lenientString("source_entity_name")
        self.source_entity_id = try c.lenientInt64("source_entity_id")
        self.source_reference_id = try c.lenientInt64("source_reference_id")
        self.source_root_id = try c.lenientInt64("source_root_id")
        self.is_wallet_entry = try c.lenientBool("is_wallet_entry")
    }
}
