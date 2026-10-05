// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct InboxMessageBody: Codable, Hashable, Sendable {
    public var action: String?
    public var body: String?
    public var type: Int64?
    public var image: String?
    public var title: String?
    public var html_body: String?
    public var additional_buttons: JSON?
    public var show_preview: Bool?
    public var show_duration_sec: Int64?
    public var enable_zoom_mode: Bool?
    public var open_links: Int64?
    public var custom_data: String?

    public init(
        action: String? = nil,
        body: String? = nil,
        type: Int64? = nil,
        image: String? = nil,
        title: String? = nil,
        html_body: String? = nil,
        additional_buttons: JSON? = nil,
        show_preview: Bool? = nil,
        show_duration_sec: Int64? = nil,
        enable_zoom_mode: Bool? = nil,
        open_links: Int64? = nil,
        custom_data: String? = nil
    ) {
        self.action = action
        self.body = body
        self.type = type
        self.image = image
        self.title = title
        self.html_body = html_body
        self.additional_buttons = additional_buttons
        self.show_preview = show_preview
        self.show_duration_sec = show_duration_sec
        self.enable_zoom_mode = enable_zoom_mode
        self.open_links = open_links
        self.custom_data = custom_data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.action = try c.lenientString("action")
        self.body = try c.lenientString("body")
        self.type = try c.lenientInt64("type")
        self.image = try c.lenientString("image")
        self.title = try c.lenientString("title")
        self.html_body = try c.lenientString("html_body")
        self.additional_buttons = try c.lenientJSON("additional_buttons")
        self.show_preview = try c.lenientBool("show_preview")
        self.show_duration_sec = try c.lenientInt64("show_duration_sec")
        self.enable_zoom_mode = try c.lenientBool("enable_zoom_mode")
        self.open_links = try c.lenientInt64("open_links")
        self.custom_data = try c.lenientString("custom_data")
    }
}
