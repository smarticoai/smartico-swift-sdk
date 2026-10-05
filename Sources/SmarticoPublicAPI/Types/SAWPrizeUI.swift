// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWPrizeUI: Codable, Hashable, Sendable {
    public var position: Int64?
    public var name: String?
    public var name_original: String?
    public var hide_prize_popup: Bool?
    public var aknowledge_message: String?
    /// Message shown instead of `aknowledge_message` when the spin is finalised as lost (`lose: true` acknowledge — games with a client-decided outcome, e.g. Voyager)
    public var aknowledge_message_lose: String?
    public var sectors: [Double]?
    public var acknowledge_type: Int64?
    public var acknowledge_dp: String?
    public var font_size: Double?
    public var font_size_mobile: Double?
    public var sound_type: Int64?
    public var second_btn: String?
    public var second_btn_action_title: String?
    public var acknowledge_dp_additional: String?
    public var acknowledge_action_title_additional: String?
    public var icon: String?
    public var replace_name_with_image: Bool?
    public var acknowledge_action_title: String?
    public var custom_win_sound: String?
    public var out_of_stock_message: String?
    public var custom_data: JSON?
    public var prize_modifiers: [String]?
    public var allow_split_decimal: Bool?
    public var hide_prize_from_history: Bool?
    public var hide_prize_till_won: Bool?
    public var requirements_to_get_prize: String?

    public init(
        position: Int64? = nil,
        name: String? = nil,
        name_original: String? = nil,
        hide_prize_popup: Bool? = nil,
        aknowledge_message: String? = nil,
        aknowledge_message_lose: String? = nil,
        sectors: [Double]? = nil,
        acknowledge_type: Int64? = nil,
        acknowledge_dp: String? = nil,
        font_size: Double? = nil,
        font_size_mobile: Double? = nil,
        sound_type: Int64? = nil,
        second_btn: String? = nil,
        second_btn_action_title: String? = nil,
        acknowledge_dp_additional: String? = nil,
        acknowledge_action_title_additional: String? = nil,
        icon: String? = nil,
        replace_name_with_image: Bool? = nil,
        acknowledge_action_title: String? = nil,
        custom_win_sound: String? = nil,
        out_of_stock_message: String? = nil,
        custom_data: JSON? = nil,
        prize_modifiers: [String]? = nil,
        allow_split_decimal: Bool? = nil,
        hide_prize_from_history: Bool? = nil,
        hide_prize_till_won: Bool? = nil,
        requirements_to_get_prize: String? = nil
    ) {
        self.position = position
        self.name = name
        self.name_original = name_original
        self.hide_prize_popup = hide_prize_popup
        self.aknowledge_message = aknowledge_message
        self.aknowledge_message_lose = aknowledge_message_lose
        self.sectors = sectors
        self.acknowledge_type = acknowledge_type
        self.acknowledge_dp = acknowledge_dp
        self.font_size = font_size
        self.font_size_mobile = font_size_mobile
        self.sound_type = sound_type
        self.second_btn = second_btn
        self.second_btn_action_title = second_btn_action_title
        self.acknowledge_dp_additional = acknowledge_dp_additional
        self.acknowledge_action_title_additional = acknowledge_action_title_additional
        self.icon = icon
        self.replace_name_with_image = replace_name_with_image
        self.acknowledge_action_title = acknowledge_action_title
        self.custom_win_sound = custom_win_sound
        self.out_of_stock_message = out_of_stock_message
        self.custom_data = custom_data
        self.prize_modifiers = prize_modifiers
        self.allow_split_decimal = allow_split_decimal
        self.hide_prize_from_history = hide_prize_from_history
        self.hide_prize_till_won = hide_prize_till_won
        self.requirements_to_get_prize = requirements_to_get_prize
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.position = try c.lenientInt64("position")
        self.name = try c.lenientString("name")
        self.name_original = try c.lenientString("name_original")
        self.hide_prize_popup = try c.lenientBool("hide_prize_popup")
        self.aknowledge_message = try c.lenientString("aknowledge_message")
        self.aknowledge_message_lose = try c.lenientString("aknowledge_message_lose")
        self.sectors = try c.lenientList(Double.self, "sectors")
        self.acknowledge_type = try c.lenientInt64("acknowledge_type")
        self.acknowledge_dp = try c.lenientString("acknowledge_dp")
        self.font_size = try c.lenientDouble("font_size")
        self.font_size_mobile = try c.lenientDouble("font_size_mobile")
        self.sound_type = try c.lenientInt64("sound_type")
        self.second_btn = try c.lenientString("second_btn")
        self.second_btn_action_title = try c.lenientString("second_btn_action_title")
        self.acknowledge_dp_additional = try c.lenientString("acknowledge_dp_additional")
        self.acknowledge_action_title_additional = try c.lenientString("acknowledge_action_title_additional")
        self.icon = try c.lenientString("icon")
        self.replace_name_with_image = try c.lenientBool("replace_name_with_image")
        self.acknowledge_action_title = try c.lenientString("acknowledge_action_title")
        self.custom_win_sound = try c.lenientString("custom_win_sound")
        self.out_of_stock_message = try c.lenientString("out_of_stock_message")
        self.custom_data = try c.lenientJSON("custom_data")
        self.prize_modifiers = try c.lenientList(String.self, "prize_modifiers")
        self.allow_split_decimal = try c.lenientBool("allow_split_decimal")
        self.hide_prize_from_history = try c.lenientBool("hide_prize_from_history")
        self.hide_prize_till_won = try c.lenientBool("hide_prize_till_won")
        self.requirements_to_get_prize = try c.lenientString("requirements_to_get_prize")
    }
}
