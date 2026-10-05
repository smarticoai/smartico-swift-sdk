// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct StoreItem: Codable, Hashable, Sendable {
    public var id: Int64?
    public var itemTypeId: Int64?
    public var itemPublicMeta: StoreItemPublicMeta?
    public var categoryIds: [Double]?
    public var canBuy: Bool?
    public var shopPool: Double?
    public var activeTillDate: Double?
    public var relatedGames: [AchRelatedGame]?

    public init(
        id: Int64? = nil,
        itemTypeId: Int64? = nil,
        itemPublicMeta: StoreItemPublicMeta? = nil,
        categoryIds: [Double]? = nil,
        canBuy: Bool? = nil,
        shopPool: Double? = nil,
        activeTillDate: Double? = nil,
        relatedGames: [AchRelatedGame]? = nil
    ) {
        self.id = id
        self.itemTypeId = itemTypeId
        self.itemPublicMeta = itemPublicMeta
        self.categoryIds = categoryIds
        self.canBuy = canBuy
        self.shopPool = shopPool
        self.activeTillDate = activeTillDate
        self.relatedGames = relatedGames
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.itemTypeId = try c.lenientInt64("itemTypeId")
        self.itemPublicMeta = try c.lenientObject(StoreItemPublicMeta.self, "itemPublicMeta")
        self.categoryIds = try c.lenientList(Double.self, "categoryIds")
        self.canBuy = try c.lenientBool("canBuy")
        self.shopPool = try c.lenientDouble("shopPool")
        self.activeTillDate = try c.lenientDouble("activeTillDate")
        self.relatedGames = try c.lenientList(AchRelatedGame.self, "relatedGames")
    }
}
