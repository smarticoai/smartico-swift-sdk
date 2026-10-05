// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TStoreCategory describes the store category item. Each store item can be assigned to 1 or more categories
public struct TStoreCategory: Codable, Hashable, Sendable {
    /// ID of the store category
    public var id: Int64?
    /// Name of the store category
    public var name: String?
    /// Order of the store category among other categories. Default value is 1
    public var order: Int64?

    public init(
        id: Int64? = nil,
        name: String? = nil,
        order: Int64? = nil
    ) {
        self.id = id
        self.name = name
        self.order = order
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.name = try c.lenientString("name")
        self.order = try c.lenientInt64("order")
    }
}
