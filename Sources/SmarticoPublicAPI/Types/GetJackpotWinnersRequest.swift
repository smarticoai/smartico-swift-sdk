// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct GetJackpotWinnersRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var api_key: String?
    public var brand_key: String?
    public var ext_user_id: String?
    /// The ID of the jackpot template
    public var jp_template_id: Int64?
    /// The number of winners to return
    public var limit: Double?
    /// The offset of the winners to return
    public var offset: Double?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        api_key: String? = nil,
        brand_key: String? = nil,
        ext_user_id: String? = nil,
        jp_template_id: Int64? = nil,
        limit: Double? = nil,
        offset: Double? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.api_key = api_key
        self.brand_key = brand_key
        self.ext_user_id = ext_user_id
        self.jp_template_id = jp_template_id
        self.limit = limit
        self.offset = offset
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.api_key = try c.lenientString("api_key")
        self.brand_key = try c.lenientString("brand_key")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.jp_template_id = try c.lenientInt64("jp_template_id")
        self.limit = try c.lenientDouble("limit")
        self.offset = try c.lenientDouble("offset")
    }
}
// Inherited fields from ProtocolRequest are flattened above.
