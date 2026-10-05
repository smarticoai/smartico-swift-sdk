// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TRaffle: Codable, Hashable, Sendable {
    /// ID of the Raffle template
    public var id: Int64?
    /// Name of the raffle
    public var name: String?
    /// Description of the raffle
    public var description: String?
    /// ID of the custom section that is linked to the raffle in the Gamification widget
    public var custom_section_id: Int64?
    /// URL of the image that represents the raffle, 890x193px
    public var image_url: String?
    /// URL of the mobile image that represents the raffle, 300x142px
    public var image_url_mobile: String?
    /// Terms and Conditions text configured by the operator for this raffle.
    /// Render it as the raffle rules. It is absent or empty when the operator
    /// configured none — hide the rules section in that case rather than
    /// substituting your own copy.
    public var hint_text: String?
    /// Custom data as string or JSON string that can be used in API to build custom UI
    /// You can request from Smartico to define fields for your specific case that will be managed from Smartico BackOffice
    /// Read more here - https://help.smartico.ai/welcome/products/tools-and-guides/custom-fields-attributes
    public var custom_data: String?
    /// Date of start
    public var start_date: Int64?
    /// Date of end
    public var end_date: Int64?
    /// Maximum numer of tickets that can be given to all users for the whole period of raffle
    public var max_tickets_count: Int64?
    /// Number of tickets that are already given to all users for this raffle
    public var current_tickets_count: Int64?
    /// List of draws that are available for this raffle.
    /// For example, if the raffle is containg one hourly draw, one daily draw and one draw on fixed date like 01/01/2022,
    /// Then the list will always return 3 draws, no matter if the draws are already executed or they are in the future.
    public var draws: [TRaffleDraw]?
    /// Ticket cap visualization
    public var ticket_cap_visualization: Int64?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        custom_section_id: Int64? = nil,
        image_url: String? = nil,
        image_url_mobile: String? = nil,
        hint_text: String? = nil,
        custom_data: String? = nil,
        start_date: Int64? = nil,
        end_date: Int64? = nil,
        max_tickets_count: Int64? = nil,
        current_tickets_count: Int64? = nil,
        draws: [TRaffleDraw]? = nil,
        ticket_cap_visualization: Int64? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.custom_section_id = custom_section_id
        self.image_url = image_url
        self.image_url_mobile = image_url_mobile
        self.hint_text = hint_text
        self.custom_data = custom_data
        self.start_date = start_date
        self.end_date = end_date
        self.max_tickets_count = max_tickets_count
        self.current_tickets_count = current_tickets_count
        self.draws = draws
        self.ticket_cap_visualization = ticket_cap_visualization
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.image_url = try c.lenientString("image_url")
        self.image_url_mobile = try c.lenientString("image_url_mobile")
        self.hint_text = try c.lenientString("hint_text")
        self.custom_data = try c.lenientString("custom_data")
        self.start_date = try c.lenientInt64("start_date")
        self.end_date = try c.lenientInt64("end_date")
        self.max_tickets_count = try c.lenientInt64("max_tickets_count")
        self.current_tickets_count = try c.lenientInt64("current_tickets_count")
        self.draws = try c.lenientList(TRaffleDraw.self, "draws")
        self.ticket_cap_visualization = try c.lenientInt64("ticket_cap_visualization")
    }
}
