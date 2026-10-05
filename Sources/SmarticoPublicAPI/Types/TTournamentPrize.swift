// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TTournamentPrize — generated from the anonymous object literal the public API
/// declares inline; the fields are exactly the ones declared there.
public struct TTournamentPrize: Codable, Hashable, Sendable {
    /// The name of the prize
    public var name: String?
    /// The description of the prize
    public var description: String?
    /// The image of the prize, 1:1 aspect ratio
    public var image_url: String?
    /// from-to range of the places to which this prize
    public var place_from: Double?
    public var place_to: Double?
    /// type of the prize: TANGIBLE, POINTS_ADD, POINTS_DEDUCT, POINTS_RESET, MINI_GAME_ATTEMPT, BONUS
    public var type: String?
    /// if the prize is points related, indicates amount of points
    public var points: Int64?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        place_from: Double? = nil,
        place_to: Double? = nil,
        type: String? = nil,
        points: Int64? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
        self.place_from = place_from
        self.place_to = place_to
        self.type = type
        self.points = points
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.place_from = try c.lenientDouble("place_from")
        self.place_to = try c.lenientDouble("place_to")
        self.type = try c.lenientString("type")
        self.points = try c.lenientInt64("points")
    }
}
