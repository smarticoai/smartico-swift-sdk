// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct IAnalyticRequestData: Codable, Hashable, Sendable {
    public var screen_name_id: Int64?
    public var screen_subname_id: AnalyticSubNames?
    public var custom_section_id: Int64?
    public var entity_id: Int64?
    public var create_date: String?
    public var user_id: Int64?
    public var label_id: Int64?
    public var brand_key: String?
    public var user_ext_id: String?
    public var interface_type: Int64?

    public init(
        screen_name_id: Int64? = nil,
        screen_subname_id: AnalyticSubNames? = nil,
        custom_section_id: Int64? = nil,
        entity_id: Int64? = nil,
        create_date: String? = nil,
        user_id: Int64? = nil,
        label_id: Int64? = nil,
        brand_key: String? = nil,
        user_ext_id: String? = nil,
        interface_type: Int64? = nil
    ) {
        self.screen_name_id = screen_name_id
        self.screen_subname_id = screen_subname_id
        self.custom_section_id = custom_section_id
        self.entity_id = entity_id
        self.create_date = create_date
        self.user_id = user_id
        self.label_id = label_id
        self.brand_key = brand_key
        self.user_ext_id = user_ext_id
        self.interface_type = interface_type
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.screen_name_id = try c.lenientInt64("screen_name_id")
        self.screen_subname_id = try c.lenientJSON("screen_subname_id")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.entity_id = try c.lenientInt64("entity_id")
        self.create_date = try c.lenientString("create_date")
        self.user_id = try c.lenientInt64("user_id")
        self.label_id = try c.lenientInt64("label_id")
        self.brand_key = try c.lenientString("brand_key")
        self.user_ext_id = try c.lenientString("user_ext_id")
        self.interface_type = try c.lenientInt64("interface_type")
    }
}
// Inherited fields from IAnalyticStoreData are flattened above.
