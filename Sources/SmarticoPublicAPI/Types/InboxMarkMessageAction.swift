// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// InboxMarkMessageAction is the response of the five inbox mutation
/// methods (`markInboxMessageAsRead`, `markAllInboxMessagesAsRead`,
/// `markUnmarkInboxMessageAsFavorite`, `deleteInboxMessage`,
/// `deleteAllInboxMessages`).
public struct InboxMarkMessageAction: Codable, Hashable, Sendable {
    /// Error code. `0` = success. See the calling method's TSDoc for
    /// the full error semantics (server returns generic codes; the
    /// five inbox mutations share the same shape).
    public var err_code: Int64?
    /// Optional server-side error message. Present only on non-zero
    /// `err_code`; may be empty even then.
    public var err_message: String?

    public init(
        err_code: Int64? = nil,
        err_message: String? = nil
    ) {
        self.err_code = err_code
        self.err_message = err_message
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.err_code = try c.lenientInt64("err_code")
        self.err_message = try c.lenientString("err_message")
    }
}
