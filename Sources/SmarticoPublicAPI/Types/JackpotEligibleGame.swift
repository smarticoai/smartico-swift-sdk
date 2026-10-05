// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotEligibleGame: Codable, Hashable, Sendable {
    /// ID of the game on Smartico side
    public var game_id: Int64?
    /// ID of the game on operator side
    public var ext_game_id: String?
    /// Name of the game
    public var name: String?
    /// Link to the game
    public var link: String?
    /// Image of the game
    public var image: String?
    /// Whether the game is enabled
    public var enabled: Bool?
    /// Categories of the game
    public var game_categories: [String]?
    /// Provider of the game
    public var game_provider: String?
    /// The link to the mobile game
    public var mobile_spec_link: String?
    /// The priority of the game
    public var priority: Int64?

    public init(
        game_id: Int64? = nil,
        ext_game_id: String? = nil,
        name: String? = nil,
        link: String? = nil,
        image: String? = nil,
        enabled: Bool? = nil,
        game_categories: [String]? = nil,
        game_provider: String? = nil,
        mobile_spec_link: String? = nil,
        priority: Int64? = nil
    ) {
        self.game_id = game_id
        self.ext_game_id = ext_game_id
        self.name = name
        self.link = link
        self.image = image
        self.enabled = enabled
        self.game_categories = game_categories
        self.game_provider = game_provider
        self.mobile_spec_link = mobile_spec_link
        self.priority = priority
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.game_id = try c.lenientInt64("game_id")
        self.ext_game_id = try c.lenientString("ext_game_id")
        self.name = try c.lenientString("name")
        self.link = try c.lenientString("link")
        self.image = try c.lenientString("image")
        self.enabled = try c.lenientBool("enabled")
        self.game_categories = try c.lenientList(String.self, "game_categories")
        self.game_provider = try c.lenientString("game_provider")
        self.mobile_spec_link = try c.lenientString("mobile_spec_link")
        self.priority = try c.lenientInt64("priority")
    }
}
