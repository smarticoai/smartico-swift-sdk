// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanPrizeTier: Codable, Hashable, Sendable {
    public var player_place_from: Double?
    public var player_place_to: Double?
    public var pool_amount: Double?
    public var distribution_type: Int64?
    public var activity_type_id: Int64?
    public var details_json: [String: JSON]?
    public var public_meta: ClanPublicMeta?

    public init(
        player_place_from: Double? = nil,
        player_place_to: Double? = nil,
        pool_amount: Double? = nil,
        distribution_type: Int64? = nil,
        activity_type_id: Int64? = nil,
        details_json: [String: JSON]? = nil,
        public_meta: ClanPublicMeta? = nil
    ) {
        self.player_place_from = player_place_from
        self.player_place_to = player_place_to
        self.pool_amount = pool_amount
        self.distribution_type = distribution_type
        self.activity_type_id = activity_type_id
        self.details_json = details_json
        self.public_meta = public_meta
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.player_place_from = try c.lenientDouble("player_place_from")
        self.player_place_to = try c.lenientDouble("player_place_to")
        self.pool_amount = try c.lenientDouble("pool_amount")
        self.distribution_type = try c.lenientInt64("distribution_type")
        self.activity_type_id = try c.lenientInt64("activity_type_id")
        self.details_json = try c.lenientDict(JSON.self, "details_json")
        self.public_meta = try c.lenientObject(ClanPublicMeta.self, "public_meta")
    }
}
