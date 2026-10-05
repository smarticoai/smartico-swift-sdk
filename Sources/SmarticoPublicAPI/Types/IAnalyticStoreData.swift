// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct IAnalyticStoreData: Codable, Hashable, Sendable {
    public var screen_name_id: Int64?
    public var screen_subname_id: AnalyticSubNames?
    public var custom_section_id: Int64?
    public var entity_id: Int64?
    public var create_date: String?

    public init(
        screen_name_id: Int64? = nil,
        screen_subname_id: AnalyticSubNames? = nil,
        custom_section_id: Int64? = nil,
        entity_id: Int64? = nil,
        create_date: String? = nil
    ) {
        self.screen_name_id = screen_name_id
        self.screen_subname_id = screen_subname_id
        self.custom_section_id = custom_section_id
        self.entity_id = entity_id
        self.create_date = create_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.screen_name_id = try c.lenientInt64("screen_name_id")
        self.screen_subname_id = try c.lenientJSON("screen_subname_id")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.entity_id = try c.lenientInt64("entity_id")
        self.create_date = try c.lenientString("create_date")
    }
}
