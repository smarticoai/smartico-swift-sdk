// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RafflePrizePublicMeta: Codable, Hashable, Sendable {
    /// Name of the prize
    public var name: String?
    /// Description of the prize
    public var description: String?
    /// URL of the image that represents the prize
    public var image_url: String?
    /// Indicates whether the chance to win should be hidden in the UI.
    public var hide_chance_to_win: Bool?
    /// Custom data field set in the backoffice prize setup.
    /// Can be used to build custom UI for gamification.
    public var custom_data: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        hide_chance_to_win: Bool? = nil,
        custom_data: String? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
        self.hide_chance_to_win = hide_chance_to_win
        self.custom_data = custom_data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.hide_chance_to_win = try c.lenientBool("hide_chance_to_win")
        self.custom_data = try c.lenientString("custom_data")
    }
}
