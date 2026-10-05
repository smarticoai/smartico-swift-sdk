import Foundation

/**
 * Histories, catalogs and paged lookups — the read-only tail of the API.
 */
extension SmarticoApi {
    /** The user's mini-game prize history (newest first), optionally per template. */
    public func getMiniGamesHistory(
        limit: Int? = nil,
        offset: Int? = nil,
        saw_template_id: Int64? = nil
    ) async throws -> [TSawHistory] {
        var payload: JSONObject = [
            "limit": JSON(limit ?? 20),
            "offset": JSON(offset ?? 0),
        ]
        if let saw_template_id = saw_template_id { payload["saw_template_id"] = JSON(saw_template_id) }
        return try await call(
            cid: ClassId.GET_SAW_HISTORY_REQUEST,
            expectCid: ClassId.GET_SAW_HISTORY_RESPONSE,
            SAWWinningHistoryResponse.self,
            payload: payload
        ).prizes.orEmpty().map {
            TSawHistory(
                template: $0.template,
                saw_template_id: $0.saw_template_id,
                saw_prize_id: $0.saw_prize_id,
                prize_amount: $0.prize_amount,
                client_request_id: $0.client_request_id,
                is_claimed: $0.is_claimed,
                create_date_ts: $0.create_date_ts,
                acknowledge_date_ts: $0.acknowledge_date_ts
            )
        }
    }

    /** Store categories (the operator's grouping of store items). */
    public func getStoreCategories() async throws -> [TStoreCategory] {
        try await call(
            cid: ClassId.GET_SHOP_CATEGORIES_REQUEST,
            expectCid: ClassId.GET_SHOP_CATEGORIES_RESPONSE,
            GetCategoriesStoreResponse.self
        ).categories.orEmpty().map { $0.toTStoreCategory() }
    }

    /**
     * What the user already bought. Same `TStoreItem` shape as the catalog, with
     * the purchase fields filled in (`purchase_ts`, `purchased_today`, …).
     */
    public func getStorePurchasedItems(limit: Int? = nil, offset: Int? = nil) async throws -> [TStoreItem] {
        try await call(
            cid: ClassId.ACH_SHOP_ITEM_HISTORY_REQUEST,
            expectCid: ClassId.ACH_SHOP_ITEM_HISTORY_RESPONSE,
            GetStoreItemsResponse.self,
            payload: [
                "limit": JSON(limit ?? 20),
                "offset": JSON(offset ?? 0),
            ]
        ).items.orEmpty().toTStoreItems().map { item in
            var item = item
            item.purchased_today = item.purchase_ts.map { isWithinPeriod($0, .TODAY) } ?? false
            item.purchased_this_week = item.purchase_ts.map { isWithinPeriod($0, .THIS_WEEK) } ?? false
            item.purchased_this_month = item.purchase_ts.map { isWithinPeriod($0, .THIS_MONTH) } ?? false
            return item
        }
    }

    /** Recent jackpot winners for one jackpot template. */
    public func getJackpotWinners(
        limit: Int? = nil,
        offset: Int? = nil,
        jp_template_id: Int64? = nil
    ) async throws -> [JackpotWinnerHistory] {
        var payload: JSONObject = [:]
        if let jp_template_id = jp_template_id { payload["jp_template_id"] = JSON(jp_template_id) }
        payload["limit"] = JSON(limit ?? 20)
        payload["offset"] = JSON(offset ?? 0)
        return try await call(
            cid: ClassId.JP_GET_WINNERS_REQUEST,
            expectCid: ClassId.JP_GET_WINNERS_RESPONSE,
            GetJackpotWinnersResponse.self,
            payload: payload
        ).winners.orEmpty()
    }

    /**
     * A winners page plus the template's win statistics (total / highest / last
     * win) in one round-trip — the same request as `getJackpotWinners`, read in
     * full. `win_stats` is always present; its wins are nil until the first win.
     */
    public func getJackpotWinStats(
        limit: Int? = nil,
        offset: Int? = nil,
        jp_template_id: Int64? = nil
    ) async throws -> TGetJackpotWinStatsResponse {
        var payload: JSONObject = [:]
        if let jp_template_id = jp_template_id { payload["jp_template_id"] = JSON(jp_template_id) }
        payload["limit"] = JSON(limit ?? 20)
        payload["offset"] = JSON(offset ?? 0)
        let r = try await call(
            cid: ClassId.JP_GET_WINNERS_REQUEST,
            expectCid: ClassId.JP_GET_WINNERS_RESPONSE,
            GetJackpotWinnersResponse.self,
            payload: payload
        )
        return TGetJackpotWinStatsResponse(
            winners: r.winners.orEmpty(),
            win_stats: JackpotWinStats(
                total_wins: r.win_stats?.total_wins ?? 0,
                highest_win: r.win_stats?.highest_win,
                last_win: r.win_stats?.last_win
            )
        )
    }

    /** Which casino games contribute to (and can trigger) a jackpot. */
    public func getJackpotEligibleGames(jp_template_id: Int64) async throws -> TGetJackpotEligibleGamesResponse {
        let r = try await call(
            cid: ClassId.JP_GET_ELIGIBLE_GAMES_REQUEST,
            expectCid: ClassId.JP_GET_ELIGIBLE_GAMES_RESPONSE,
            GetJackpotEligibleGamesResponse.self,
            payload: ["jp_template_id": JSON(jp_template_id)]
        )
        // the wire nests display fields under game_public_meta; the public shape is flat
        return TGetJackpotEligibleGamesResponse(
            eligible_games: r.eligible_games.orEmpty().enumerated().map { i, g in
                let meta = g.game_public_meta?.object
                return JackpotEligibleGame(
                    game_id: g.ach_game_id,
                    ext_game_id: g.ext_game_id,
                    name: meta.str("name"),
                    link: meta.str("link"),
                    image: meta.str("image"),
                    enabled: meta?["enabled"].flatMap { $0.string.flatMap { $0 == "true" ? true : $0 == "false" ? false : nil } },
                    game_provider: meta.str("game_provider"),
                    mobile_spec_link: meta.str("mobile_spec_link"),
                    priority: Int64(i + 1)
                )
            }
        )
    }

    /** Prizes the user has won in a raffle (paged). */
    public func getRaffleWonPrizes(
        raffle_id: Int64,
        offset: Int? = nil,
        limit: Int? = nil
    ) async throws -> GetRaffleWonPrizesResponse {
        try requireArg(raffle_id != 0, "raffle_id is required")
        return try await call(
            cid: ClassId.RAF_GET_WON_PRIZES_REQUEST,
            expectCid: ClassId.RAF_GET_WON_PRIZES_RESPONSE,
            GetRaffleWonPrizesResponse.self,
            payload: [
                "raffle_id": JSON(raffle_id),
                "offset": JSON(offset ?? 0),
                "limit": JSON(limit ?? 20),
            ]
        )
    }

    /**
     * Operator-authored custom sections (extra tabs/pages in the widget). The
     * server keys them by id; entries without a section type are ignored.
     *
     * (Ordered by id: Kotlin keeps the wire order, a Swift dictionary has none.)
     */
    public func getCustomSections() async throws -> [TUICustomSection] {
        let r = try await call(
            cid: ClassId.GET_CUSTOM_SECTIONS_REQUEST,
            expectCid: ClassId.GET_CUSTOM_SECTIONS_RESPONSE,
            GetCustomSectionsResponse.self
        )
        guard let sections = r.customSections?.object else { return [] }
        return try sortedByNumericKey(sections).compactMap { key, value -> TUICustomSection? in
            guard let obj = value.object else { return nil }
            var section = try decodeWire(TUICustomSection.self, obj)
            if (section.section_type_id ?? 0) < 1 { return nil }
            section.id = Int64(key)
            return section
        }
    }
}

extension StoreCategory {
    func toTStoreCategory() -> TStoreCategory { TStoreCategory(id: id, name: publicMeta?.name, order: publicMeta?.order) }
}

private extension Optional where Wrapped == JSONObject {
    func str(_ key: String) -> String? { self?[key]?.string }
}
