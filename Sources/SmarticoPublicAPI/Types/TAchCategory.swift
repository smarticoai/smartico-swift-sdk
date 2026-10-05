// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TAchCategory describes a mission/badge category. Categories are
/// operator-defined groupings, configured per-label by the brand operator,
/// shared across BOTH missions and badges — the same list is returned for
/// both entity types. A mission or badge can belong to **zero or more**
/// categories (many-to-many) via its `category_ids: number[]` field on
/// `TMissionOrBadge`.
///
/// Returned by `Smartico.api.getAchCategories()`. See that method's TSDoc
/// for translation, refresh, and rendering details.
public struct TAchCategory: Codable, Hashable, Sendable {
    /// Stable numeric ID of the category. Used as the key when joining to
    /// `TMissionOrBadge.category_ids: number[]`.
    public var id: Int64?
    /// Display name of the category, pre-translated server-side. Never null.
    public var name: String?
    /// Relative display position (lower = appears first). Default 1 when the
    /// operator did not configure an explicit order.
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
