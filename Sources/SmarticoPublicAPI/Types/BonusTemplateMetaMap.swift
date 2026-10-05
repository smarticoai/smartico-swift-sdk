// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct BonusTemplateMetaMap: Codable, Hashable, Sendable {
    public var description: String?
    public var acknowledge: String?
    public var image_url: String?
    public var redirect_url: String?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var name: String?

    public init(
        description: String? = nil,
        acknowledge: String? = nil,
        image_url: String? = nil,
        redirect_url: String? = nil,
        name: String? = nil
    ) {
        self.description = description
        self.acknowledge = acknowledge
        self.image_url = image_url
        self.redirect_url = redirect_url
        self.name = name
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.description = try c.lenientString("description")
        self.acknowledge = try c.lenientString("acknowledge")
        self.image_url = try c.lenientString("image_url")
        self.redirect_url = try c.lenientString("redirect_url")
        self.name = try c.lenientString("name")
    }
}
