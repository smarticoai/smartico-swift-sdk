// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct InboxMessage: Codable, Hashable, Sendable {
    public var createDate: String?
    public var body: InboxMessageBody?
    public var engagement_uid: String?
    public var is_read: Bool?
    public var is_starred: Bool?
    public var is_deleted: Bool?
    public var category_id: Int64?
    public var expire_on_dt: Double?

    public init(
        createDate: String? = nil,
        body: InboxMessageBody? = nil,
        engagement_uid: String? = nil,
        is_read: Bool? = nil,
        is_starred: Bool? = nil,
        is_deleted: Bool? = nil,
        category_id: Int64? = nil,
        expire_on_dt: Double? = nil
    ) {
        self.createDate = createDate
        self.body = body
        self.engagement_uid = engagement_uid
        self.is_read = is_read
        self.is_starred = is_starred
        self.is_deleted = is_deleted
        self.category_id = category_id
        self.expire_on_dt = expire_on_dt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.createDate = try c.lenientString("createDate")
        self.body = try c.lenientObject(InboxMessageBody.self, "body")
        self.engagement_uid = try c.lenientString("engagement_uid")
        self.is_read = try c.lenientBool("is_read")
        self.is_starred = try c.lenientBool("is_starred")
        self.is_deleted = try c.lenientBool("is_deleted")
        self.category_id = try c.lenientInt64("category_id")
        self.expire_on_dt = try c.lenientDouble("expire_on_dt")
    }
}
