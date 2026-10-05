// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TournamentPublicMeta: Codable, Hashable, Sendable {
    /// Name of tournament
    public var name: String?
    /// 1st image
    public var image_url: String?
    /// 2nd image
    public var image_url2: String?
    /// 2nd image for mobile
    public var image_url2_mobile: String?
    /// Description, html capable
    public var description: String?
    /// Short explanation of prize pool
    public var prize_pool_short: String?
    /// Message to show when user is not matching to the segment allowed to register (error code 30005 in registration response)
    public var segment_dont_match_message: String?
    /// Short explanation of registration price
    public var custom_price_text: String?
    /// Indicator if the scores of other users should be shown in the leaderboard of tournament
    public var show_other_users_score: Bool?
    public var custom_section_id: Int64?
    public var only_in_custom_section: Bool?
    public var label_tag: String?
    public var custom_label_tag: String?
    public var featured: Bool?
    public var position: Int64?
    public var custom_data: String?

    public init(
        name: String? = nil,
        image_url: String? = nil,
        image_url2: String? = nil,
        image_url2_mobile: String? = nil,
        description: String? = nil,
        prize_pool_short: String? = nil,
        segment_dont_match_message: String? = nil,
        custom_price_text: String? = nil,
        show_other_users_score: Bool? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        label_tag: String? = nil,
        custom_label_tag: String? = nil,
        featured: Bool? = nil,
        position: Int64? = nil,
        custom_data: String? = nil
    ) {
        self.name = name
        self.image_url = image_url
        self.image_url2 = image_url2
        self.image_url2_mobile = image_url2_mobile
        self.description = description
        self.prize_pool_short = prize_pool_short
        self.segment_dont_match_message = segment_dont_match_message
        self.custom_price_text = custom_price_text
        self.show_other_users_score = show_other_users_score
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.label_tag = label_tag
        self.custom_label_tag = custom_label_tag
        self.featured = featured
        self.position = position
        self.custom_data = custom_data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.image_url = try c.lenientString("image_url")
        self.image_url2 = try c.lenientString("image_url2")
        self.image_url2_mobile = try c.lenientString("image_url2_mobile")
        self.description = try c.lenientString("description")
        self.prize_pool_short = try c.lenientString("prize_pool_short")
        self.segment_dont_match_message = try c.lenientString("segment_dont_match_message")
        self.custom_price_text = try c.lenientString("custom_price_text")
        self.show_other_users_score = try c.lenientBool("show_other_users_score")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.label_tag = try c.lenientString("label_tag")
        self.custom_label_tag = try c.lenientString("custom_label_tag")
        self.featured = try c.lenientBool("featured")
        self.position = try c.lenientInt64("position")
        self.custom_data = try c.lenientString("custom_data")
    }
}
