// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RafflePublicMeta: Codable, Hashable, Sendable {
    /// Name of the raffle
    public var name: String?
    /// Description of the raffle
    public var description: String?
    /// ID of the custom section that is linked to the raffle in the Gamification widget
    public var custom_section_id: Int64?
    /// URL of the image that represents the raffle
    public var image_url: String?
    /// URL of the mobile image that represents the raffle
    public var image_url_mobile: String?
    /// Text for Terms and Conditions
    public var hint_text: String?
    /// Custom data as string or JSON string that can be used in API to build custom UI
    /// You can request from Smartico to define fields for your specific case that will be managed from Smartico BackOffice
    /// Read more here - <https://help.smartico.ai/welcome/products/tools-and-guides/custom-fields-attributes>
    public var custom_data: String?
    /// - Value 1 (Counter): Shows a real-time "Tickets Remaining" display available during the whole Raffle activity.
    /// - Value 2 (Message): Will show a specific message that triggers only when the cap is reached and inform users that tickets will be no longer be issued.
    public var ticket_cap_visualization: Int64?

    public init(
        name: String? = nil,
        description: String? = nil,
        custom_section_id: Int64? = nil,
        image_url: String? = nil,
        image_url_mobile: String? = nil,
        hint_text: String? = nil,
        custom_data: String? = nil,
        ticket_cap_visualization: Int64? = nil
    ) {
        self.name = name
        self.description = description
        self.custom_section_id = custom_section_id
        self.image_url = image_url
        self.image_url_mobile = image_url_mobile
        self.hint_text = hint_text
        self.custom_data = custom_data
        self.ticket_cap_visualization = ticket_cap_visualization
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.image_url = try c.lenientString("image_url")
        self.image_url_mobile = try c.lenientString("image_url_mobile")
        self.hint_text = try c.lenientString("hint_text")
        self.custom_data = try c.lenientString("custom_data")
        self.ticket_cap_visualization = try c.lenientInt64("ticket_cap_visualization")
    }
}
