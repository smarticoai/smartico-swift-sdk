// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AchCategory: Codable, Hashable, Sendable {
    public var id: Int64?
    public var publicMeta: AchCategoryPublicMeta?

    public init(
        id: Int64? = nil,
        publicMeta: AchCategoryPublicMeta? = nil
    ) {
        self.id = id
        self.publicMeta = publicMeta
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.publicMeta = try c.lenientObject(AchCategoryPublicMeta.self, "publicMeta")
    }
}
