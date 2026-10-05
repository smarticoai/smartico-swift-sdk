// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetRelatedAchTourRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var related_game_id: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        related_game_id: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.related_game_id = related_game_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.related_game_id = try c.lenientString("related_game_id")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
