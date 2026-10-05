// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWDoAcknowledgeBatchResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var api_key: String?
    public var brand_key: String?
    public var ext_user_id: String?
    public var results: JSON?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        api_key: String? = nil,
        brand_key: String? = nil,
        ext_user_id: String? = nil,
        results: JSON? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.api_key = api_key
        self.brand_key = brand_key
        self.ext_user_id = ext_user_id
        self.results = results
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.api_key = try c.lenientString("api_key")
        self.brand_key = try c.lenientString("brand_key")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.results = try c.lenientJSON("results")
    }
}
// Inherited fields from ProtocolRequest are flattened above.
