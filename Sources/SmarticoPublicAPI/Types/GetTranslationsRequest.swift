// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetTranslationsRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var api_key: String?
    public var brand_key: String?
    public var ext_user_id: String?
    public var hash_code: Double?
    public var areas: [Int64]?
    public var lang_code: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        api_key: String? = nil,
        brand_key: String? = nil,
        ext_user_id: String? = nil,
        hash_code: Double? = nil,
        areas: [Int64]? = nil,
        lang_code: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.api_key = api_key
        self.brand_key = brand_key
        self.ext_user_id = ext_user_id
        self.hash_code = hash_code
        self.areas = areas
        self.lang_code = lang_code
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.api_key = try c.lenientString("api_key")
        self.brand_key = try c.lenientString("brand_key")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.hash_code = try c.lenientDouble("hash_code")
        self.areas = try c.lenientList(Int64.self, "areas")
        self.lang_code = try c.lenientString("lang_code")
    }
}
// Inherited fields from ProtocolRequest are flattened above.
