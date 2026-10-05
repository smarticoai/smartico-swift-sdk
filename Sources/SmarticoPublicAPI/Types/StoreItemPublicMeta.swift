// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct StoreItemPublicMeta: Codable, Hashable, Sendable {
    public var price: String?
    public var image_url: String?
    public var purchase_type: Int64?
    public var name: String?
    public var description: String?
    public var label_tag: String?
    public var custom_label_tag: String?
    public var limit_message: String?
    public var priority: Int64?
    public var related_items: [Double]?
    public var hint_text: String?
    public var custom_data: String?
    public var show_timer: Bool?
    public var cant_buy_message: String?
    public var discount_prize: Double?
    public var discount_prize_ribbon: String?
    public var custom_ribbon_image: String?
    public var purchase_limit_message: String?
    public var custom_section_id: Int64?
    public var only_in_custom_section: Bool?
    public var custom_section_type_id: Int64?

    public init(
        price: String? = nil,
        image_url: String? = nil,
        purchase_type: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        label_tag: String? = nil,
        custom_label_tag: String? = nil,
        limit_message: String? = nil,
        priority: Int64? = nil,
        related_items: [Double]? = nil,
        hint_text: String? = nil,
        custom_data: String? = nil,
        show_timer: Bool? = nil,
        cant_buy_message: String? = nil,
        discount_prize: Double? = nil,
        discount_prize_ribbon: String? = nil,
        custom_ribbon_image: String? = nil,
        purchase_limit_message: String? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        custom_section_type_id: Int64? = nil
    ) {
        self.price = price
        self.image_url = image_url
        self.purchase_type = purchase_type
        self.name = name
        self.description = description
        self.label_tag = label_tag
        self.custom_label_tag = custom_label_tag
        self.limit_message = limit_message
        self.priority = priority
        self.related_items = related_items
        self.hint_text = hint_text
        self.custom_data = custom_data
        self.show_timer = show_timer
        self.cant_buy_message = cant_buy_message
        self.discount_prize = discount_prize
        self.discount_prize_ribbon = discount_prize_ribbon
        self.custom_ribbon_image = custom_ribbon_image
        self.purchase_limit_message = purchase_limit_message
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.custom_section_type_id = custom_section_type_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.price = try c.lenientString("price")
        self.image_url = try c.lenientString("image_url")
        self.purchase_type = try c.lenientInt64("purchase_type")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.label_tag = try c.lenientString("label_tag")
        self.custom_label_tag = try c.lenientString("custom_label_tag")
        self.limit_message = try c.lenientString("limit_message")
        self.priority = try c.lenientInt64("priority")
        self.related_items = try c.lenientList(Double.self, "related_items")
        self.hint_text = try c.lenientString("hint_text")
        self.custom_data = try c.lenientString("custom_data")
        self.show_timer = try c.lenientBool("show_timer")
        self.cant_buy_message = try c.lenientString("cant_buy_message")
        self.discount_prize = try c.lenientDouble("discount_prize")
        self.discount_prize_ribbon = try c.lenientString("discount_prize_ribbon")
        self.custom_ribbon_image = try c.lenientString("custom_ribbon_image")
        self.purchase_limit_message = try c.lenientString("purchase_limit_message")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.custom_section_type_id = try c.lenientInt64("custom_section_type_id")
    }
}
