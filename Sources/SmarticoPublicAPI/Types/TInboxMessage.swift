// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TInboxMessage is the lightweight envelope returned by
/// `Smartico.api.getInboxMessages()`. Fetch the rich body (title,
/// preview, icon, html_body, buttons) separately via
/// `Smartico.api.getInboxMessageBody(message_guid)`.
public struct TInboxMessage: Codable, Hashable, Sendable {
    /// Unique identifier of the message. Pass to `getInboxMessageBody`
    /// and the mark / favorite / delete mutations.
    public var message_guid: String?
    /// Date-time the message was sent, as a `"dd/MM/yyyy HH:mm:ss"` string
    /// (server local — NOT ISO-8601, so `new Date(sent_date)` will not parse it).
    public var sent_date: String?
    /// `true` when the message has been marked read.
    public var read: Bool?
    /// `true` when the message has been starred (favorited).
    public var favorite: Bool?
    /// Operator-assigned category ({@link InboxCategories}).
    public var category_id: Int64?
    /// Expiry timestamp as Unix-ms epoch. Server filters out expired
    /// messages from list responses — consumers rarely see this set
    /// unless the expiry is upcoming.
    public var expire_on_dt: Double?

    public init(
        message_guid: String? = nil,
        sent_date: String? = nil,
        read: Bool? = nil,
        favorite: Bool? = nil,
        category_id: Int64? = nil,
        expire_on_dt: Double? = nil
    ) {
        self.message_guid = message_guid
        self.sent_date = sent_date
        self.read = read
        self.favorite = favorite
        self.category_id = category_id
        self.expire_on_dt = expire_on_dt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.message_guid = try c.lenientString("message_guid")
        self.sent_date = try c.lenientString("sent_date")
        self.read = try c.lenientBool("read")
        self.favorite = try c.lenientBool("favorite")
        self.category_id = try c.lenientInt64("category_id")
        self.expire_on_dt = try c.lenientDouble("expire_on_dt")
    }
}
