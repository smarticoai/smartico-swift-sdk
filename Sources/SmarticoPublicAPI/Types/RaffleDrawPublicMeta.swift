// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RaffleDrawPublicMeta: Codable, Hashable, Sendable {
    /// Name of the draw, e.g. 'Daily draw'
    public var name: String?
    /// Description of the draw
    public var description: String?
    /// URL of the image that represents the draw
    public var image_url: String?
    /// URL of the moible image that represents the draw
    public var image_url_mobile: String?
    /// URL of the icon that represents the draw
    public var icon_url: String?
    /// URL of the background image that will be used in the draw list item
    public var background_image_url: String?
    /// URL of the moible background image that will be used in the draw list item
    public var background_image_url_mobile: String?
    /// Show if the draw is grand and is marked as special
    public var is_grand: Bool?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        image_url_mobile: String? = nil,
        icon_url: String? = nil,
        background_image_url: String? = nil,
        background_image_url_mobile: String? = nil,
        is_grand: Bool? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
        self.image_url_mobile = image_url_mobile
        self.icon_url = icon_url
        self.background_image_url = background_image_url
        self.background_image_url_mobile = background_image_url_mobile
        self.is_grand = is_grand
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.image_url_mobile = try c.lenientString("image_url_mobile")
        self.icon_url = try c.lenientString("icon_url")
        self.background_image_url = try c.lenientString("background_image_url")
        self.background_image_url_mobile = try c.lenientString("background_image_url_mobile")
        self.is_grand = try c.lenientBool("is_grand")
    }
}
