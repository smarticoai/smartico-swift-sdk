// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ResponseIdentify: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    public var user_id: Int64?
    public var ext_user_id: String?
    public var public_username: String?
    public var avatar_id: String?
    public var job: Bool?
    public var props: PublicProperties?
    public var pubic_username_set: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        user_id: Int64? = nil,
        ext_user_id: String? = nil,
        public_username: String? = nil,
        avatar_id: String? = nil,
        job: Bool? = nil,
        props: PublicProperties? = nil,
        pubic_username_set: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.user_id = user_id
        self.ext_user_id = ext_user_id
        self.public_username = public_username
        self.avatar_id = avatar_id
        self.job = job
        self.props = props
        self.pubic_username_set = pubic_username_set
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.user_id = try c.lenientInt64("user_id")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_id = try c.lenientString("avatar_id")
        self.job = try c.lenientBool("job")
        self.props = try c.lenientObject(PublicProperties.self, "props")
        self.pubic_username_set = try c.lenientBool("pubic_username_set")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
