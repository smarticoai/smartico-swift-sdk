// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TInboxMessageBody is the rich body of one inbox message.
/// Returned by `Smartico.api.getInboxMessageBody(message_guid)`.
/// Fetched from a CDN (not over WebSocket).
public struct TInboxMessageBody: Codable, Hashable, Sendable {
    /// Display title.
    public var title: String?
    /// Short preview text (typically rendered alongside the title in list items).
    public var preview_body: String?
    /// Message icon URL (128×128 px recommended).
    public var icon: String?
    /// Click-action — either a deep-link (e.g. `'dp:deposit'`) or a
    /// plain URL. The literal `'dp:inbox'` indicates the message has a
    /// rich `html_body`; for any other value `html_body` and `buttons`
    /// are absent. Pass to `Smartico.dp(action)` for safe execution.
    public var action: String?
    /// Rich HTML body. Populated only when `action === 'dp:inbox'`.
    public var html_body: String?
    /// Up to 2 additional action buttons. Populated only when
    /// `action === 'dp:inbox'`.
    public var buttons: JSON?
    /// Operator-defined custom data. The SDK auto-parses JSON-looking
    /// strings, so at runtime this is `any` despite the `string` type.
    public var custom_data: JSON?
    /// Whether to show a short preview popup when the message arrives.
    /// `false` means store it in the inbox silently; missing means `true`.
    public var show_preview: Bool?
    /// How long the preview popup stays visible, in seconds.
    /// `null` or missing means 7 seconds.
    public var show_duration_sec: Int64?

    public init(
        title: String? = nil,
        preview_body: String? = nil,
        icon: String? = nil,
        action: String? = nil,
        html_body: String? = nil,
        buttons: JSON? = nil,
        custom_data: JSON? = nil,
        show_preview: Bool? = nil,
        show_duration_sec: Int64? = nil
    ) {
        self.title = title
        self.preview_body = preview_body
        self.icon = icon
        self.action = action
        self.html_body = html_body
        self.buttons = buttons
        self.custom_data = custom_data
        self.show_preview = show_preview
        self.show_duration_sec = show_duration_sec
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.title = try c.lenientString("title")
        self.preview_body = try c.lenientString("preview_body")
        self.icon = try c.lenientString("icon")
        self.action = try c.lenientString("action")
        self.html_body = try c.lenientString("html_body")
        self.buttons = try c.lenientJSON("buttons")
        self.custom_data = try c.lenientJSON("custom_data")
        self.show_preview = try c.lenientBool("show_preview")
        self.show_duration_sec = try c.lenientInt64("show_duration_sec")
    }
}
