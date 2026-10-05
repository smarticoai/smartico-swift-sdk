// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct ClanPublicMeta: Codable, Hashable, Sendable {
    public var name: String?
    public var description: String?
    public var image_url: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
    }
}
