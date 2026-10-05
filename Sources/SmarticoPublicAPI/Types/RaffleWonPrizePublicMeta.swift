// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Presentation meta for a won prize.
public struct RaffleWonPrizePublicMeta: Codable, Hashable, Sendable {
    /// Name of the prize, e.g. '1 $'.
    public var name: String?
    /// Indicates whether the chance to win should be hidden in the UI.
    public var hide_chance_to_win: Bool?
    /// URL of the image that represents the prize.
    public var image_url: String?

    public init(
        name: String? = nil,
        hide_chance_to_win: Bool? = nil,
        image_url: String? = nil
    ) {
        self.name = name
        self.hide_chance_to_win = hide_chance_to_win
        self.image_url = image_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.hide_chance_to_win = try c.lenientBool("hide_chance_to_win")
        self.image_url = try c.lenientString("image_url")
    }
}
