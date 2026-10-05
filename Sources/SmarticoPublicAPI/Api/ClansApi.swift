import Foundation

extension SmarticoApi {
    /**
     * Clans — player teams that compete as a unit in clan-based tournaments.
     *
     * `user_clan_id` on the list tells you which clan the user belongs to (null =
     * none), and `cooldown_until` is when they may switch clans again after
     * leaving one.
     */
    public func getClans() async throws -> TClans {
        let r = try await call(
            cid: ClassId.GET_CLAN_LIST_REQUEST,
            expectCid: ClassId.GET_CLAN_LIST_RESPONSE,
            GetClanListResponse.self
        )
        return TClans(
            clans: (r.clans ?? []).map { c in
                TClan(
                    clan_id: c.clan_id,
                    public_meta: c.public_meta.flatMap(clanMetaJSON),
                    member_count: c.member_count,
                    capacity_limit: c.capacity_limit,
                    entry_fee_currency_type_id: c.entry_fee_currency_type_id,
                    entry_fee_amount: c.entry_fee_amount,
                    rating_position: c.rating_position,
                    rating_score: c.rating_score
                )
            },
            user_clan_id: r.user_clan_id,
            cooldown_until: r.cooldown_until,
            join_date: r.join_date
        )
    }

    /** One clan in detail, including its member roster with contribution scores. */
    public func getClanInfo(clanId: Int64) async throws -> TClanInfo {
        let r = try await call(
            cid: ClassId.GET_CLAN_INFO_REQUEST,
            expectCid: ClassId.GET_CLAN_INFO_RESPONSE,
            GetClanInfoResponse.self,
            payload: ["clan_id": JSON(clanId)]
        )
        let c = r.clanInfo
        let domain = Env.avatarUrl(conn.label)
        // members carry only avatar_id — expand it like the rest of the SDK
        let members: [JSON] = (c?.members ?? []).map { m in
            .object([
                "user_id": clanValue(m.user_id),
                "public_username": clanValue(m.public_username),
                "avatar_id": clanValue(m.avatar_id),
                "avatar_real_id": clanValue(m.avatar_real_id),
                "avatar_url": clanValue(m.avatar_id.map { avatarUrlOf($0, domain) }),
                "position": clanValue(m.position),
                "contribution_score": clanValue(m.contribution_score),
                "is_me": clanValue(m.is_me),
                "clean_ext_user_id": clanValue(m.clean_ext_user_id),
            ])
        }
        return TClanInfo(
            clan_id: c?.clan_id,
            public_meta: c?.public_meta.flatMap(clanMetaJSON),
            member_count: c?.member_count,
            capacity_limit: c?.capacity_limit,
            entry_fee_currency_type_id: c?.entry_fee_currency_type_id,
            entry_fee_amount: c?.entry_fee_amount,
            rating_position: c?.rating_position,
            rating_score: c?.rating_score,
            cooldown_until: c?.cooldown_until,
            members: .array(members)
        )
    }

    /**
     * Join a clan. A non-zero `errCode` means the join was refused (clan full, user
     * on cooldown, entry fee unaffordable).
     */
    public func joinClan(clanId: Int64) async throws -> TClanJoinResult {
        let r = try await call(
            cid: ClassId.JOIN_CLAN_REQUEST,
            expectCid: ClassId.JOIN_CLAN_RESPONSE,
            JoinClanResponse.self,
            payload: [
                "clan_id": JSON(clanId),
                "join_source_id": 0, // the public API doesn't expose join sources
            ]
        )
        return TClanJoinResult(errCode: r.errCode ?? 0, errMsg: r.errMsg ?? "")
    }

    /** The members of one clan inside a clan-based tournament, with their scores. */
    public func getClanTournamentPlayers(tournamentInstanceId: Int64, clanId: Int64) async throws -> TClanTournamentPlayers {
        let r = try await call(
            cid: ClassId.GET_CLAN_TOURNAMENT_PLAYERS_REQUEST,
            expectCid: ClassId.GET_CLAN_TOURNAMENT_PLAYERS_RESPONSE,
            GetClanTournamentPlayersResponse.self,
            payload: [
                "tournament_instance_id": JSON(tournamentInstanceId),
                "clan_id": JSON(clanId),
            ]
        )
        let players: [JSON] = (r.players ?? []).map { p in
            .object([
                "user_id": clanValue(p.userId),
                "clean_ext_user_id": clanValue(p.cleanExtUserId),
                "public_username": clanValue(p.userAltName),
                "avatar_id": clanValue(p.avatar_id),
                "avatar_real_id": clanValue(p.avatar_real_id),
                "avatar_url": clanValue(p.avatar_url),
                "position": clanValue(p.position),
                "scores": clanValue(p.scores),
                "is_me": clanValue(p.isMe),
            ])
        }
        return TClanTournamentPlayers(
            tournament_instance_id: r.tournament_instance_id,
            players: .array(players)
        )
    }
}

private func avatarUrlOf(_ avatarId: String, _ domain: String) -> String {
    if avatarId.hasPrefix("http") { return avatarId }
    var base = Substring(domain)
    while base.hasSuffix("/") { base = base.dropLast() }
    return base + "/avatar/" + avatarId
}

/**
 * `apiJson.encodeToJsonElement(ClanPublicMeta.serializer(), it)`: the meta as a
 * JSON object. Absent fields are left out (the synthesized `encode(to:)` skips
 * nils, as kotlinx's `explicitNulls = false` does).
 */
private func clanMetaJSON(_ meta: ClanPublicMeta) -> JSON? {
    guard let data = try? JSONEncoder().encode(meta) else { return nil }
    return try? JSON.parse(data)
}

// kotlinx `put(key, value)` with a nullable value writes JSON null for nil.
private func clanValue(_ v: Int64?) -> JSON { v.map { JSON($0) } ?? .null }
private func clanValue(_ v: Double?) -> JSON { v.map { JSON($0) } ?? .null }
private func clanValue(_ v: Bool?) -> JSON { v.map { JSON($0) } ?? .null }
private func clanValue(_ v: String?) -> JSON { v.map { JSON($0) } ?? .null }
