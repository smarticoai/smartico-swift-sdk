// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetClanInfoRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var clan_id: Int64?
    public var force_language: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        clan_id: Int64? = nil,
        force_language: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.clan_id = clan_id
        self.force_language = force_language
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.clan_id = try c.lenientInt64("clan_id")
        self.force_language = try c.lenientString("force_language")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
