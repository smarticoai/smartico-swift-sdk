import Foundation

/**
 * Per-entity detail lookups and the remaining list endpoints.
 */
extension SmarticoApi {
    /**
     * One tournament in full: the lobby fields plus the leaderboard, prize
     * structure, the user's own row and (for clan tournaments) the clan standings.
     */
    public func getTournamentInstanceInfo(tournamentInstanceId: Int64) async throws -> TTournamentDetailed {
        let r = try await call(
            cid: ClassId.GET_TOURNAMENT_INFO_REQUEST,
            expectCid: ClassId.GET_TOURNAMENT_INFO_RESPONSE,
            GetTournamentInfoResponse.self,
            payload: ["tournamentInstanceId": JSON(tournamentInstanceId)]
        )
        let info = r.tournamentInfo?.object
        guard let lobbyJson = info?["tournamentLobbyInfo"]?.object else {
            throw SmarticoApiPreconditionError(message: "Tournament \(tournamentInstanceId) not found or no longer active")
        }
        let lobby = try decodeWire(Tournament.self, lobbyJson)
        // the lobby half is exactly a list item, so reuse that transform
        guard let base = [lobby].toTTournaments().first else {
            throw SmarticoApiPreconditionError(message: "Tournament \(tournamentInstanceId) could not be transformed")
        }

        // Kotlin re-encodes the typed response (`encodeToJsonElement`) and reads
        // the remaining fields off that; same here, so both see the same data.
        let raw = try JSON.parse(JSONEncoder().encode(r)).object ?? [:]
        return TTournamentDetailed(
            instance_id: base.instance_id,
            tournament_id: base.tournament_id,
            name: base.name,
            description: base.description,
            image1: base.image1,
            image2: base.image2,
            image2_mobile: base.image2_mobile,
            prize_pool_short: base.prize_pool_short,
            custom_price_text: base.custom_price_text,
            segment_dont_match_message: base.segment_dont_match_message,
            custom_section_id: base.custom_section_id,
            only_in_custom_section: base.only_in_custom_section,
            custom_data: base.custom_data,
            is_featured: base.is_featured,
            ribbon: base.ribbon,
            priority: base.priority,
            start_time: base.start_time,
            end_time: base.end_time,
            registration_type: base.registration_type,
            registration_count: base.registration_count,
            is_user_registered: base.is_user_registered,
            players_min_count: base.players_min_count,
            players_max_count: base.players_max_count,
            registration_status: base.registration_status,
            duration_ms: base.duration_ms,
            registration_cost_points: base.registration_cost_points,
            registration_cost_gems: base.registration_cost_gems,
            registration_cost_diamonds: base.registration_cost_diamonds,
            is_active: base.is_active,
            is_can_register: base.is_can_register,
            is_cancelled: base.is_cancelled,
            is_finished: base.is_finished,
            is_in_progress: base.is_in_progress,
            is_upcoming: base.is_upcoming,
            min_scores_win: base.min_scores_win,
            hide_leaderboard_min_scores: base.hide_leaderboard_min_scores,
            total_scores: base.total_scores,
            is_clan_based: base.is_clan_based,
            related_games: lobby.related_games,
            // The protocol rows carry their own field names (userAltName,
            // cleanExtUserId, numeric prize type); the public API exposes them
            // renamed and with the prize type spelled out, so translate them here
            // instead of handing the raw protocol rows over.
            players: info?["players"].decodeList(TournamentPlayer.self)?.map { $0.toTournamentPlayer() },
            me: raw["userPosition"].decodeObject(TournamentPlayer.self)?.toTournamentMe(),
            prizes: raw["prizeStructure"]?.object?["prizes"]
                .decodeList(TournamentPrize.self)?.map { $0.toTournamentPrize() },
            clan_leaderboard: raw["clanLeaderboard"].decodeList(TTournamentClanRank.self),
            user_clan_id: raw["userClanId"]?.string.flatMap { Int64($0) },
            clan_prize_structure: raw["clanPrizes"]
        )
    }

    /** One raffle draw run in detail, including its winners. */
    public func getRaffleDrawRun(
        raffle_id: Int64,
        run_id: Int64,
        winners_from: Int? = nil,
        winners_to: Int? = nil
    ) async throws -> TRaffleDraw {
        try requireArg(raffle_id != 0 && run_id != 0, "both raffle_id and run_id are required")
        var payload: JSONObject = [
            "raffle_id": JSON(raffle_id),
            "run_id": JSON(run_id),
        ]
        if let winners_from = winners_from { payload["winners_offset"] = JSON(winners_from) }
        if let winners_to = winners_to { payload["winners_limit"] = JSON(winners_to) }
        let r = try await call(
            cid: ClassId.RAF_GET_DRAW_RUN_REQUEST,
            expectCid: ClassId.RAF_GET_DRAW_RUN_RESPONSE,
            GetDrawRunResponse.self,
            payload: payload
        )
        guard let draw = r.draw else {
            throw SmarticoApiPreconditionError(message: "Draw run \(run_id) not found for raffle \(raffle_id)")
        }
        return [draw].toTDraws()[0]
    }

    /** Past runs of a raffle's draws (the history a UI shows under "previous draws"). */
    public func getRaffleDrawRunsHistory(raffle_id: Int64, draw_id: Int64? = nil) async throws -> [TRaffleDrawRun] {
        try requireArg(raffle_id != 0, "raffle_id is required")
        var payload: JSONObject = ["raffle_id": JSON(raffle_id)]
        if let draw_id = draw_id { payload["draw_id"] = JSON(draw_id) }
        let r = try await call(
            cid: ClassId.RAF_GET_DRAW_HISTORY_REQUEST,
            expectCid: ClassId.RAF_GET_DRAW_HISTORY_RESPONSE,
            GetRaffleDrawRunsHistoryResponse.self,
            payload: payload
        )
        return r.draw_runs.orEmpty().map { item in
            let meta = item.public_meta
            return TRaffleDrawRun(
                id: item.draw_id,
                run_id: item.run_id,
                name: meta?.name,
                description: meta?.description,
                image_url: meta?.image_url,
                image_url_mobile: meta?.image_url_mobile,
                icon_url: meta?.icon_url,
                background_image_url: meta?.background_image_url,
                background_image_url_mobile: meta?.background_image_url_mobile,
                is_grand: meta?.is_grand,
                execution_ts: item.execution_ts,
                // the JS transform (drawRunHistoryTransform) carries these four as well —
                // without them a "won by me" filter or a claim button can never trigger
                actual_execution_ts: item.actual_execution_ts,
                ticket_start_ts: item.ticket_start_ts,
                is_winner: item.is_winner,
                has_unclaimed_prize: item.has_unclaimed_prize
            )
        }
    }

    /**
     * Every leaderboard configured for the label (one entry per period type).
     *
     * (Kotlin returns them in wire order; a Swift dictionary has none, so they
     * come back ordered by period type id.)
     */
    public func getLeaderBoards() async throws -> [LeaderBoardDetailsT] {
        let r = try await conn.request(cid: ClassId.GET_LEADERS_BOARD_REQUEST, expectCid: ClassId.GET_LEADERS_BOARD_RESPONSE)
        guard let map = r["map"]?.object else { return [] }
        let domain = Env.avatarUrl(conn.label)
        return sortedByNumericKey(map).compactMap { _, entry in
            (try? decodeWire(LeaderBoardDetails.self, entry))?.toLeaderBoardDetailsT(domain)
        }
    }

    /**
     * The user's points/gems/diamonds history within a time window (epoch seconds).
     * `from`/`to` page the result; the server caps a page at 50 entries.
     */
    public func getActivityLog(
        startTimeSeconds: Int64,
        endTimeSeconds: Int64,
        from: Int,
        to: Int,
        types: [Int64]? = nil,
        src_types: [Int64]? = nil
    ) async throws -> [TActivityLog] {
        var payload: JSONObject = [
            "startTimeSeconds": JSON(startTimeSeconds),
            "endTimeSeconds": JSON(endTimeSeconds),
            "limit": JSON(to - from > 50 ? 50 : to - from),
            "offset": JSON(from),
        ]
        if let list = types { payload["types"] = .array(list.map { JSON($0) }) }
        if let list = src_types { payload["src_types"] = .array(list.map { JSON($0) }) }
        let r = try await call(
            cid: ClassId.GET_POINT_HISTORY_REQUEST,
            expectCid: ClassId.GET_POINT_HISTORY_RESPONSE,
            GetActivityLogResponse.self,
            payload: payload
        )
        return r.logHistory.orEmpty().map { $0.toTActivityLog() }
    }

    /** Mark every inbox message as read. */
    public func markAllInboxMessagesAsRead() async throws -> InboxMarkMessageAction {
        try await conn.request(
            cid: ClassId.MARK_INBOX_READ_REQUEST,
            expectCid: ClassId.MARK_INBOX_READ_RESPONSE,
            payload: ["all_read": true]
        ).toInboxAction()
    }

    /** Delete every inbox message. */
    public func deleteAllInboxMessages() async throws -> InboxMarkMessageAction {
        try await conn.request(
            cid: ClassId.MARK_INBOX_DELETED_REQUEST,
            expectCid: ClassId.MARK_INBOX_DELETED_RESPONSE,
            payload: ["all_deleted": true]
        ).toInboxAction()
    }

    /**
     * Report that an engagement was shown. Fire-and-forget: the server records the
     * impression, nothing is awaited. `activityType` is 31 for inbox, 30 for popups.
     */
    public func reportImpressionEvent(engagement_uid: String, activityType: Int64) {
        conn.send(
            cid: ClassId.CLIENT_ENGAGEMENT_IMPRESSION_REQUEST,
            payload: [
                "engagement_uid": JSON(engagement_uid),
                "activityType": JSON(activityType),
            ]
        )
    }

    /** Report that the user acted on an engagement (tapped its CTA). Fire-and-forget. */
    public func reportClickEvent(engagement_uid: String, activityType: Int64, action: String? = nil) {
        var payload: JSONObject = [
            "engagement_uid": JSON(engagement_uid),
            "activityType": JSON(activityType),
        ]
        if let action = action { payload["action"] = JSON(action) }
        conn.send(cid: ClassId.CLIENT_ENGAGEMENT_ACTION_REQUEST, payload: payload)
    }
}

extension ActivityLogEntry {
    func toTActivityLog() -> TActivityLog {
        let activityTypeId = type
        let balanceType: Int64
        switch activityTypeId {
        case ActivityLogActivities.Gems: balanceType = UserBalanceType.Gems
        case ActivityLogActivities.Diamonds: balanceType = UserBalanceType.Diamonds
        default: balanceType = UserBalanceType.Points
        }
        return TActivityLog(
            // create_date may arrive as {seconds} or as a plain number
            create_date: create_date?.object?["seconds"]?.string.flatMap { Int64($0) }
                ?? create_date?.string.flatMap { Double($0) }.map { Lenient.truncate($0) },
            user_ext_id: user_ext_id,
            crm_brand_id: crm_brand_id.flatMap { Int64($0) },
            type: balanceType,
            // `amount` carries the real delta; points rows may carry it in `points_collected` instead (JS: `amount ?? points_collected`)
            amount: amount ?? points_collected.map { Double($0) },
            balance: balance ?? user_points_balance.map { Double($0) },
            total_ever: user_points_ever.map { Double($0) },
            source_type_id: source_type_id,
            activity_type_id: activityTypeId,
            context_value_1: ctx_1,
            meta: ctx_meta,
            source_reference_id: source_ref_id,
            source_root_id: source_root_id
        )
    }
}

private extension Dictionary where Key == String, Value == JSON {
    func toInboxAction() -> InboxMarkMessageAction {
        InboxMarkMessageAction(
            err_code: self["errCode"]?.string.flatMap { Double($0) }.map { Lenient.truncate($0) },
            err_message: self["errMsg"]?.string
        )
    }
}

/**
 * A server map's entries in a stable order: numeric keys ascending (they are
 * ids), then any others by text. Kotlin keeps the wire order of a JsonObject;
 * a Swift dictionary has no order to keep.
 */
func sortedByNumericKey(_ map: JSONObject) -> [(key: String, value: JSON)] {
    map.sorted { a, b in
        switch (Int64(a.key), Int64(b.key)) {
        case let (x?, y?): return x < y
        case (.some, nil): return true
        case (nil, .some): return false
        case (nil, nil): return a.key < b.key
        }
    }
}
