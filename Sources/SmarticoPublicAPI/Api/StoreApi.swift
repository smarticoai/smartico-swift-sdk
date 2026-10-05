import Foundation

extension SmarticoApi {
    /** The points/gems store: what the user can buy with their gamification currency. */
    public func getStoreItems() async throws -> [TStoreItem] {
        (try await call(
            cid: ClassId.GET_SHOP_ITEMS_REQUEST,
            expectCid: ClassId.GET_SHOP_ITEMS_RESPONSE,
            GetStoreItemsResponse.self
        ).items ?? []).toTStoreItems()
    }
}

extension Array where Element == StoreItem {
    func toTStoreItems() -> [TStoreItem] {
        filter { ($0.id ?? 0) >= 1 }.map { r -> TStoreItem in
            let meta = r.itemPublicMeta
            // "custom" means the operator typed their own ribbon text
            let ribbonText = meta?.label_tag == "custom" ? meta?.custom_label_tag : meta?.label_tag
            let ribbon: JSON? = ribbonText.map { JSON.string($0) }
            return TStoreItem(
                id: r.id,
                name: meta?.name,
                description: meta?.description,
                image: meta?.image_url,
                type: storeItemTypeName(r.itemTypeId),
                // the wire delivers price as a STRING — coerce to the number the type promises
                price: meta?.price.flatMap { Double($0) },
                ribbon: ribbon,
                limit_message: meta?.limit_message,
                purchase_limit_message: meta?.purchase_limit_message,
                priority: meta?.priority ?? 0,
                related_item_ids: meta?.related_items?.map { Lenient.truncate($0) },
                // disabled games are dropped, and priority is the display order
                related_games: r.relatedGames,
                can_buy: r.canBuy,
                category_ids: (r.categoryIds ?? []).map { Lenient.truncate($0) },
                pool: r.shopPool,
                custom_data: jsonOrText(meta?.custom_data),
                hint_text: meta?.hint_text,
                purchase_type: purchaseTypeName(meta?.purchase_type),
                active_till_date: r.activeTillDate.map { Lenient.truncate($0) },
                show_timer: meta?.show_timer,
                discounted_price: meta?.discount_prize,
                discount_price_ribbon: meta?.discount_prize_ribbon,
                custom_ribbon_image: meta?.custom_ribbon_image,
                custom_section_id: meta?.custom_section_id,
                only_in_custom_section: meta?.only_in_custom_section,
                custom_section_type_id: meta?.custom_section_type_id,
                cant_buy_message: meta?.cant_buy_message
            )
        }
    }
}

/** Which currency the item is bought with; points unless stated otherwise. */
private func purchaseTypeName(_ id: Int64?) -> String {
    switch id {
    case StoreItemPurchaseType.Gems: return "gems"
    case StoreItemPurchaseType.Diamonds: return "diamonds"
    default: return "points"
    }
}

private func storeItemTypeName(_ id: Int64?) -> String {
    switch id {
    case StoreItemType.Bonus: return StoreItemTypeName.Bonus
    case StoreItemType.Tangible: return StoreItemTypeName.Tangible
    case StoreItemType.MiniGameSpin: return StoreItemTypeName.MiniGameSpin
    case StoreItemType.ChangeLevel: return StoreItemTypeName.ChangeLevel
    case StoreItemType.PrizeDrop: return StoreItemTypeName.PrizeDrop
    case StoreItemType.RaffleTicket: return StoreItemTypeName.RaffleTicket
    default: return StoreItemTypeName.Unknown
    }
}
