// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TournamentPrize: Codable, Hashable, Sendable {
    public var name: String?
    public var description: String?
    public var image_url: String?
    public var place_from: Double?
    public var place_to: Double?
    public var type: Int64?
    public var points: Int64?
    public var gems: Double?
    public var diamonds: Double?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        place_from: Double? = nil,
        place_to: Double? = nil,
        type: Int64? = nil,
        points: Int64? = nil,
        gems: Double? = nil,
        diamonds: Double? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
        self.place_from = place_from
        self.place_to = place_to
        self.type = type
        self.points = points
        self.gems = gems
        self.diamonds = diamonds
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.place_from = try c.lenientDouble("place_from")
        self.place_to = try c.lenientDouble("place_to")
        self.type = try c.lenientInt64("type")
        self.points = try c.lenientInt64("points")
        self.gems = try c.lenientDouble("gems")
        self.diamonds = try c.lenientDouble("diamonds")
    }
}
