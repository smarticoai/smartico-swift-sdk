import Foundation

extension SmarticoApi {
    /**
     * Leaderboards.
     *
     * `getPreviousPeriod` selects the period: 0 = the running one, 1 = the previous
     * period, 2 = the one before it, … — that's how a UI offers "yesterday" for a
     * daily board or "last week" for a weekly one.
     */
    public func getLeaderBoard(
        periodType: Int64,
        getPreviousPeriod: Int = 0
    ) async throws -> LeaderBoardDetailsT? {
        let resp = try await call(
            cid: ClassId.GET_LEADERS_BOARD_REQUEST,
            expectCid: ClassId.GET_LEADERS_BOARD_RESPONSE,
            GetLeaderBoardsResponse.self,
            payload: [
                "period_type_id": JSON(periodType),
                "snapshot_offset": JSON(getPreviousPeriod),
                "include_users": true,
            ]
        )
        // The response is keyed by period type; pick the requested board.
        // (Kotlin falls back to the first entry in wire order; a Swift dictionary
        // has none, so the fallback is the lowest key — the same board whenever
        // the server lists period types in ascending order.)
        guard let map = resp.map?.object else { return nil }
        guard let entry = map[String(periodType)] ?? map.keys.sorted().first.flatMap({ map[$0] }) else { return nil }
        let board: LeaderBoardDetails
        do {
            board = try apiDecoder.decode(LeaderBoardDetails.self, from: entry.data(sortedKeys: false))
        } catch {
            throw SmarticoError.decoding(error)
        }
        return board.toLeaderBoardDetailsT(Env.avatarUrl(conn.label))
    }

    /**
     * The operator's privacy configuration for leaderboard rendering. Apply it to
     * every row you draw: the standings from `getLeaderBoard` always carry
     * `avatar_url`, `level_id` and `points`, so honouring these flags is the
     * caller's responsibility — ignoring them shows data the operator asked to
     * keep private.
     *
     * Each flag means "hide" when `true`:
     *  - `LeaderBoardSettingsT.hide_avatars` — draw rows without the player avatar.
     *  - `LeaderBoardSettingsT.hide_levels` — draw rows without the level name.
     *  - `LeaderBoardSettingsT.hide_other_points` — hide `points` on every row
     *    except the current user's; the user always sees their own points.
     *
     * On an unconfigured label `hide_avatars` and `hide_levels` default to `false`
     * (show) while `hide_other_points` defaults to `true` (hide). The asymmetry is
     * deliberate — it is what the operator sees on their other surfaces, so a
     * custom leaderboard agrees with them instead of exposing hidden points.
     *
     * The settings arrive with the session handshake, so this never issues a
     * round-trip. Read-only; also available in visitor mode.
     */
    public func getLeaderBoardSettings() async -> LeaderBoardSettingsT {
        let settings = await gamificationUiSettings()
        func flag(_ key: String) -> Bool? { settings?[key]?.bool }
        return LeaderBoardSettingsT(
            hide_avatars: flag("hide_avatars_leaderboards") == true,
            hide_levels: flag("leaderboard_hide_levels") == true,
            // Deliberately asymmetric: points stay hidden unless the operator
            // explicitly turned the flag off.
            hide_other_points: flag("leaderboard_hide_other_points") != false
        )
    }

    /**
     * The gamification UI settings the operator configured for this label, or
     * `nil` when none are set. Test accounts read the operator's test variant
     * when one exists; everyone else reads the live settings.
     */
    private func gamificationUiSettings() async -> JSONObject? {
        // The setting is stored as a JSON *string*, not as a nested object.
        func parse(_ raw: JSON?) -> JSONObject? {
            guard case .string(let text)? = raw, !text.isEmpty else { return nil }
            guard let obj = (try? JSON.parse(text))?.object, !obj.isEmpty else { return nil }
            return obj
        }

        let isTestAccount = await conn.getPublicProps()["core_is_test_account"]?.bool == true
        let test = isTestAccount
            ? parse(await conn.getLabelSetting(PublicLabelSettings.GAMIFICATION_UI_SETTINGS_TEST_V2))
            : nil
        if let test = test { return test }
        return parse(await conn.getLabelSetting(PublicLabelSettings.GAMIFICATION_UI_SETTINGS_V2))
    }
}

extension LeaderBoardDetails {
    func toLeaderBoardDetailsT(_ avatarDomain: String) -> LeaderBoardDetailsT {
        LeaderBoardDetailsT(
            board_id: board_id,
            name: board_public_meta?.name,
            description: board_public_meta?.description,
            rules: board_public_meta?.rules,
            period_type_id: period_type_id,
            version_id: versiod_id, // wire typo, kept for parity
            create_date: create_date,
            // reward_points is a flat array: index 0 is 1st place, 1 is 2nd, …
            rewards: reward_points?.enumerated().map { i, points in
                LeaderBoardsRewardsT(place: Double(i + 1), points: points)
            },
            users: (positions ?? []).map { $0.toLeaderBoardUserT(avatarDomain, isMe: false) },
            me: userPosition?.toLeaderBoardUserT(avatarDomain, isMe: true)
        )
    }
}

private extension LeaderBoardPosition {
    func toLeaderBoardUserT(_ avatarDomain: String, isMe: Bool) -> LeaderBoardUserT {
        LeaderBoardUserT(
            public_username: public_username ?? user_alt_name,
            // rows carry only avatar_id; expand it against the environment's image CDN
            // rows carry only avatar_id — expand it the way the SDK does elsewhere
            avatar_url: avatar_url ?? avatar_id.map { id -> String in
                if id.hasPrefix("http") { return id }
                var base = Substring(avatarDomain)
                while base.hasSuffix("/") { base = base.dropLast() }
                return base + "/avatar/" + id
            },
            level_id: level_id,
            position: position_in_board,
            points: points_accumulated,
            // the `me` entry is the current user by definition; rows use the server flag
            is_me: isMe ? true : is_me
        )
    }
}
