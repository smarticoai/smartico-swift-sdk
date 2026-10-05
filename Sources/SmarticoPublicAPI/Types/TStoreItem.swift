// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TStoreItem describes the information of the store item defined in the system
public struct TStoreItem: Codable, Hashable, Sendable {
    /// ID of the store item
    public var id: Int64?
    /// Name of the store item, translated to the user language
    public var name: String?
    /// Description of the store item, translated to the user language
    public var description: String?
    /// URL of the image of the store item, 256x256px
    public var image: String?
    /// Type of the store item. Can be 'bonus' or 'tangible' or different others.
    public var type: String?
    /// The price of the store item in the gamification points
    public var price: Double?
    /// The ribbon of the store item. Can be 'sale', 'hot', 'new', 'vip' or URL to the image in case of custom ribbon, 250x300px
    public var ribbon: JSON?
    /// The message that should be shown to the user if he is not eligible to buy it. this message can be used to explain the reason why user cannot buy the item, e.g. 'You should be VIP to buy this item' and can be used in case can_buy property is false.
    ///         The message is translated to the user language.
    /// *Note**: when user is trying to buy the item, the response from server can return custom error messages that can be shown to the user as well
    public var limit_message: String?
    /// The message that should be shown to the user if they are not eligible to buy it because of purchase limitation. This message can be used to explain the reason why user cannot buy the item, e.g. 'Item is no more available today. Come back Friday'.
    ///         The message is translated to the user language.
    /// *Note**: when user is trying to buy the item, the response from server can return custom error messages that can be shown to the user as well
    public var purchase_limit_message: String?
    /// The priority of the store item. Can be used to sort the items in the store
    public var priority: Int64?
    /// The list of IDs of the related items. Can be used to show the related items in the store
    public var related_item_ids: [Int64]?
    /// List of casino games (or other types of entities) related to the store item
    public var related_games: [AchRelatedGame]?
    /// The indicator if the user can buy the item
    ///  This indicator is taking into account the segment conditions for the store item, the price of item towards users balance,
    public var can_buy: Bool?
    /// The list of IDs of the categories where the store item is assigned, information about categories can be retrieved with getStoreCategories method
    public var category_ids: [Int64]?
    /// Items remaining in the pool available for purchase. `null` = unlimited
    /// supply. Positive integer = remaining stock. `0` = sold out but still
    /// returned (operator may instead hide pool-empty items entirely).
    public var pool: Double?
    /// The custom data of the store item defined by operator. Can be a JSON object, string or number
    public var custom_data: JSON?
    /// The T&C text for the store item
    public var hint_text: String?
    /// Purchase time to show in purchase history screen
    public var purchase_ts: Int64?
    /// The amount of points you can purchase an item
    public var purchase_points_amount: Int64?
    /// Flag for store item indicating that it was purchased today
    public var purchased_today: Bool?
    /// Flag for store item indicating that it was purchased this week
    public var purchased_this_week: Bool?
    /// Flag for store item indicating that it was purchased this month
    public var purchased_this_month: Bool?
    /// The type of the purchase
    public var purchase_type: String?
    /// The date when the store item will be available till
    public var active_till_date: Int64?
    /// Should countdown timer be shown when `active_till_date` is present
    public var show_timer: Bool?
    /// The discounted price of the store item
    public var discounted_price: Double?
    /// The ribbon of the discounted price.
    public var discount_price_ribbon: String?
    /// The custom ribbon image of the discounted price, 250x300px
    public var custom_ribbon_image: String?
    /// The ID of the custom section where the store item is assigned
    public var custom_section_id: Int64?
    /// The indicator if the store item is visible only in the custom section and should be hidden from the main overview of store items
    public var only_in_custom_section: Bool?
    /// ID of specific Custom Section type
    public var custom_section_type_id: Int64?
    /// The message that should be shown to the user if they are not eligible to buy it. This message can be used to explain the reason why user cannot buy the item, e.g. 'You should be VIP to buy this item'.
    public var cant_buy_message: String?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        image: String? = nil,
        type: String? = nil,
        price: Double? = nil,
        ribbon: JSON? = nil,
        limit_message: String? = nil,
        purchase_limit_message: String? = nil,
        priority: Int64? = nil,
        related_item_ids: [Int64]? = nil,
        related_games: [AchRelatedGame]? = nil,
        can_buy: Bool? = nil,
        category_ids: [Int64]? = nil,
        pool: Double? = nil,
        custom_data: JSON? = nil,
        hint_text: String? = nil,
        purchase_ts: Int64? = nil,
        purchase_points_amount: Int64? = nil,
        purchased_today: Bool? = nil,
        purchased_this_week: Bool? = nil,
        purchased_this_month: Bool? = nil,
        purchase_type: String? = nil,
        active_till_date: Int64? = nil,
        show_timer: Bool? = nil,
        discounted_price: Double? = nil,
        discount_price_ribbon: String? = nil,
        custom_ribbon_image: String? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        custom_section_type_id: Int64? = nil,
        cant_buy_message: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.type = type
        self.price = price
        self.ribbon = ribbon
        self.limit_message = limit_message
        self.purchase_limit_message = purchase_limit_message
        self.priority = priority
        self.related_item_ids = related_item_ids
        self.related_games = related_games
        self.can_buy = can_buy
        self.category_ids = category_ids
        self.pool = pool
        self.custom_data = custom_data
        self.hint_text = hint_text
        self.purchase_ts = purchase_ts
        self.purchase_points_amount = purchase_points_amount
        self.purchased_today = purchased_today
        self.purchased_this_week = purchased_this_week
        self.purchased_this_month = purchased_this_month
        self.purchase_type = purchase_type
        self.active_till_date = active_till_date
        self.show_timer = show_timer
        self.discounted_price = discounted_price
        self.discount_price_ribbon = discount_price_ribbon
        self.custom_ribbon_image = custom_ribbon_image
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.custom_section_type_id = custom_section_type_id
        self.cant_buy_message = cant_buy_message
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image = try c.lenientString("image")
        self.type = try c.lenientString("type")
        self.price = try c.lenientDouble("price")
        self.ribbon = try c.lenientJSON("ribbon")
        self.limit_message = try c.lenientString("limit_message")
        self.purchase_limit_message = try c.lenientString("purchase_limit_message")
        self.priority = try c.lenientInt64("priority")
        self.related_item_ids = try c.lenientList(Int64.self, "related_item_ids")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.can_buy = try c.lenientBool("can_buy")
        self.category_ids = try c.lenientList(Int64.self, "category_ids")
        self.pool = try c.lenientDouble("pool")
        self.custom_data = try c.lenientJSON("custom_data")
        self.hint_text = try c.lenientString("hint_text")
        self.purchase_ts = try c.lenientInt64("purchase_ts")
        self.purchase_points_amount = try c.lenientInt64("purchase_points_amount")
        self.purchased_today = try c.lenientBool("purchased_today")
        self.purchased_this_week = try c.lenientBool("purchased_this_week")
        self.purchased_this_month = try c.lenientBool("purchased_this_month")
        self.purchase_type = try c.lenientString("purchase_type")
        self.active_till_date = try c.lenientInt64("active_till_date")
        self.show_timer = try c.lenientBool("show_timer")
        self.discounted_price = try c.lenientDouble("discounted_price")
        self.discount_price_ribbon = try c.lenientString("discount_price_ribbon")
        self.custom_ribbon_image = try c.lenientString("custom_ribbon_image")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.custom_section_type_id = try c.lenientInt64("custom_section_type_id")
        self.cant_buy_message = try c.lenientString("cant_buy_message")
    }
}
