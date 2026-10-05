// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One operator-configured navigation entry. Returned by `getCustomSections()`.
/// `section_type_id` is the dispatch key — it determines which page component the
/// consumer mounts when the user opens this section.
public struct TUICustomSection: Codable, Hashable, Sendable {
    /// Stable numeric ID of the section.
    public var id: Int64?
    /// Raw HTML body for `HTML_PAGE` sections; Liquid template body for `LEVELS` (Liquid) sections.
    public var body: String?
    /// CDN URL of the section's nav icon, 64x64 px square.
    public var menu_img: String?
    /// Display name shown next to the nav icon. Pre-translated server-side.
    public var menu_name: String?
    /// JSON-serialized list of skin image overrides for themed sections (e.g. `MISSION_CUSTOM_LAYOUT`).
    public var custom_skin_images: String?
    /// Dispatch key — see {@link AchCustomSectionType}.
    public var section_type_id: Int64?
    /// Themed-layout name for `MISSION_CUSTOM_LAYOUT` sections; see {@link AchCustomLayoutTheme}.
    public var theme: String?
    /// Custom CSS for themed layouts.
    public var generic_custom_css: String?
    /// Which tabs to render for `MISSIONS_CATEGORY` sections; see {@link AchMissionsTabsOptions}.
    public var mission_tabs_options: Int64?
    /// Mission-filter rule for the Overview tab; see {@link AchOverviewMissionsFilter}.
    public var overview_missions_filter: Int64?
    /// Maximum number of missions shown in the Overview tab.
    public var overview_missions_count: Int64?
    /// Click target for `REDIRECT_LINK` sections — either a Smartico DP string (`dp:…`) or an external URL.
    public var url_or_dp: String?
    /// Data-context selectors for Liquid templates; see {@link LiquidEntityData}.
    public var liquid_entity_data: [Int64]?
    /// Tournament ID for a single-tournament Liquid template (`LiquidEntityData.Tournament`).
    public var ach_tournament_id: Int64?
    /// Operator debug flag — when `true`, Liquid renders raw context data instead of the templated HTML.
    public var show_raw_data: Bool?
    /// Liquid template ID resolved server-side; the rendered body is delivered in `body`.
    public var liquid_template: Double?
    /// Category IDs the section filters badges by — correlate with `getAchCategories()`.
    public var ach_category_ids: [Int64]?
    /// Category IDs the section filters store items by — correlate with `getStoreCategories()`.
    public var shop_category_ids: [Int64]?
    /// Raffle ID for `RAFFLE` sections (and `LiquidEntityData.SingleRaffle` Liquid templates).
    public var raffle_id: Int64?

    public init(
        id: Int64? = nil,
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
        show_raw_data: Bool? = nil,
        liquid_template: Double? = nil,
        ach_category_ids: [Int64]? = nil,
        shop_category_ids: [Int64]? = nil,
        raffle_id: Int64? = nil
    ) {
        self.id = id
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
        self.show_raw_data = show_raw_data
        self.liquid_template = liquid_template
        self.ach_category_ids = ach_category_ids
        self.shop_category_ids = shop_category_ids
        self.raffle_id = raffle_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
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
        self.show_raw_data = try c.lenientBool("show_raw_data")
        self.liquid_template = try c.lenientDouble("liquid_template")
        self.ach_category_ids = try c.lenientList(Int64.self, "ach_category_ids")
        self.shop_category_ids = try c.lenientList(Int64.self, "shop_category_ids")
        self.raffle_id = try c.lenientInt64("raffle_id")
    }
}
