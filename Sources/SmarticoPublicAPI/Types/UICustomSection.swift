// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct UICustomSection: Codable, Hashable, Sendable {
    public var body: String?
    public var menu_img: String?
    public var menu_name: String?
    public var custom_skin_images: String?
    public var section_type_id: Int64?
    public var theme: String?
    public var generic_custom_css: String?
    public var mission_tabs_options: Int64?
    public var overview_missions_filter: Int64?
    public var overview_missions_count: Int64?
    public var url_or_dp: String?
    public var liquid_entity_data: [Int64]?
    public var ach_tournament_id: Int64?
    public var raffle_id: Int64?
    public var show_raw_data: Bool?
    public var liquid_template: Double?
    public var ach_category_ids: [Int64]?
    public var shop_category_ids: [Int64]?

    public init(
        body: String? = nil,
        menu_img: String? = nil,
        menu_name: String? = nil,
        custom_skin_images: String? = nil,
        section_type_id: Int64? = nil,
        theme: String? = nil,
        generic_custom_css: String? = nil,
        mission_tabs_options: Int64? = nil,
        overview_missions_filter: Int64? = nil,
        overview_missions_count: Int64? = nil,
        url_or_dp: String? = nil,
        liquid_entity_data: [Int64]? = nil,
        ach_tournament_id: Int64? = nil,
        raffle_id: Int64? = nil,
        show_raw_data: Bool? = nil,
        liquid_template: Double? = nil,
        ach_category_ids: [Int64]? = nil,
        shop_category_ids: [Int64]? = nil
    ) {
        self.body = body
        self.menu_img = menu_img
        self.menu_name = menu_name
        self.custom_skin_images = custom_skin_images
        self.section_type_id = section_type_id
        self.theme = theme
        self.generic_custom_css = generic_custom_css
        self.mission_tabs_options = mission_tabs_options
        self.overview_missions_filter = overview_missions_filter
        self.overview_missions_count = overview_missions_count
        self.url_or_dp = url_or_dp
        self.liquid_entity_data = liquid_entity_data
        self.ach_tournament_id = ach_tournament_id
        self.raffle_id = raffle_id
        self.show_raw_data = show_raw_data
        self.liquid_template = liquid_template
        self.ach_category_ids = ach_category_ids
        self.shop_category_ids = shop_category_ids
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.body = try c.lenientString("body")
        self.menu_img = try c.lenientString("menu_img")
        self.menu_name = try c.lenientString("menu_name")
        self.custom_skin_images = try c.lenientString("custom_skin_images")
        self.section_type_id = try c.lenientInt64("section_type_id")
        self.theme = try c.lenientString("theme")
        self.generic_custom_css = try c.lenientString("generic_custom_css")
        self.mission_tabs_options = try c.lenientInt64("mission_tabs_options")
        self.overview_missions_filter = try c.lenientInt64("overview_missions_filter")
        self.overview_missions_count = try c.lenientInt64("overview_missions_count")
        self.url_or_dp = try c.lenientString("url_or_dp")
        self.liquid_entity_data = try c.lenientList(Int64.self, "liquid_entity_data")
        self.ach_tournament_id = try c.lenientInt64("ach_tournament_id")
        self.raffle_id = try c.lenientInt64("raffle_id")
        self.show_raw_data = try c.lenientBool("show_raw_data")
        self.liquid_template = try c.lenientDouble("liquid_template")
        self.ach_category_ids = try c.lenientList(Int64.self, "ach_category_ids")
        self.shop_category_ids = try c.lenientList(Int64.self, "shop_category_ids")
    }
}
