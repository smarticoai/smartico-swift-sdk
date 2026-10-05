// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AchCategoryPublicMeta: Codable, Hashable, Sendable {
    public var name: String?
    public var order: Int64?

    public init(
        name: String? = nil,
        order: Int64? = nil
    ) {
        self.name = name
        self.order = order
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.order = try c.lenientInt64("order")
    }
}
