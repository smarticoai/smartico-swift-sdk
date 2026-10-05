import Foundation

extension SmarticoApi {
    /** The tournament lobby: every tournament visible to the user, with their own row. */
    public func getTournamentsList() async throws -> [TTournament] {
        (try await call(
            cid: ClassId.GET_TOURNAMENT_LOBBY_REQUEST,
            expectCid: ClassId.GET_TOURNAMENT_LOBBY_RESPONSE,
            GetTournamentsResponse.self
        ).tournaments ?? []).toTTournaments()
    }
}

extension Array where Element == Tournament {
    /**
     * Wire shape → public shape. Display fields come from `publicMeta`; the six
     * `is_*` flags are derived from the instance status, and the buy-in amount is
     * routed into the field matching the registration type.
     */
    func toTTournaments() -> [TTournament] {
        filter { ($0.tournamentId ?? 0.0) >= 1 }.map { r -> TTournament in
            let meta = r.publicMeta
            let status = r.tournamentInstanceStatus
            func statusIn(_ set: Set<Int64>) -> Bool { status.map { set.contains($0) } ?? false }
            // "custom" means the operator typed their own ribbon text
            let ribbonText = meta?.label_tag == "custom" ? meta?.custom_label_tag : meta?.label_tag
            let ribbon: JSON? = ribbonText.map { JSON.string($0) }
            let prizes: [TTournamentPrize]? = r.prizeStructure?.object?["prizes"].decodeList()
            return TTournament(
                instance_id: r.tournamentInstanceId.map { Lenient.truncate($0) },
                tournament_id: r.tournamentId.map { Lenient.truncate($0) },
                name: meta?.name,
                description: meta?.description,
                image1: meta?.image_url,
                image2: meta?.image_url2,
                image2_mobile: meta?.image_url2_mobile,
                prize_pool_short: meta?.prize_pool_short,
                custom_price_text: meta?.custom_price_text,
                segment_dont_match_message: meta?.segment_dont_match_message,
                custom_section_id: meta?.custom_section_id,
                only_in_custom_section: meta?.only_in_custom_section,
                custom_data: jsonOrText(meta?.custom_data),
                is_featured: meta?.featured,
                ribbon: ribbon,
                priority: meta?.position,
                me: r.tournamentPlayer?.toTournamentMe(),
                prizes: prizes,
                start_time: r.startTimeTs.map { Lenient.truncate($0) },
                end_time: r.endTimeTs.map { Lenient.truncate($0) },
                registration_type: registrationTypeName(r.registrationType),
                registration_count: r.registrationCount,
                is_user_registered: r.isUserRegistered,
                players_min_count: r.playersMinCount,
                players_max_count: r.playersMaxCount,
                registration_status: registrationStatusName(r.tournamentRegistrationStatus),
                duration_ms: r.durationMs,
                registration_cost_points:
                    r.registrationType == TournamentRegistrationType.BUY_IN_POINTS ? r.buyInAmount.map { Lenient.truncate($0) } : nil,
                registration_cost_gems:
                    r.registrationType == TournamentRegistrationType.BUY_IN_GEMS ? r.buyInAmount : nil,
                registration_cost_diamonds:
                    r.registrationType == TournamentRegistrationType.BUY_IN_DIAMONDS ? r.buyInAmount : nil,
                is_active: statusIn([
                    TournamentInstanceStatus.PUBLISHED,
                    TournamentInstanceStatus.REGISTER,
                    TournamentInstanceStatus.STARTED,
                ]),
                is_can_register: isCanRegister(r),
                is_cancelled: status == TournamentInstanceStatus.CANCELLED,
                is_finished: statusIn([
                    TournamentInstanceStatus.FINISHED,
                    TournamentInstanceStatus.CANCELLED,
                    TournamentInstanceStatus.FINALIZING,
                ]),
                is_in_progress: status == TournamentInstanceStatus.STARTED,
                is_upcoming: statusIn([
                    TournamentInstanceStatus.PUBLISHED,
                    TournamentInstanceStatus.REGISTER,
                ]),
                min_scores_win: r.minScoreToWin,
                hide_leaderboard_min_scores: r.hideLeaderboardsMinScores,
                total_scores: r.totalScores,
                is_clan_based: r.isClanBased
            )
        }
    }
}

/**
 * Can this user still join? Qualified-but-unregistered always can; otherwise
 * the tournament must have room, not be auto-registration, and be in its
 * registration window (or started with late registration allowed).
 */
private func isCanRegister(_ t: Tournament) -> Bool {
    if t.tournamentRegistrationStatus == TournamentRegistrationStatus.QUALIFIED_PENDING_REGISTRATION { return true }
    let hasRoom = t.playersMaxCount == nil || t.playersMaxCount == 0 || t.playersMaxCount != t.registrationCount
    let windowOpen = t.tournamentInstanceStatus == TournamentInstanceStatus.REGISTER ||
        (t.tournamentInstanceStatus == TournamentInstanceStatus.STARTED && t.allowLateRegistration == true)
    return t.isUserRegistered != true &&
        hasRoom &&
        t.registrationType != TournamentRegistrationType.AUTO &&
        windowOpen
}

extension TournamentPlayer {
    /** The player row as the public API shapes it (`is_me` is dropped for "me"). */
    func toTournamentPlayer() -> TTournamentPlayer {
        TTournamentPlayer(
            public_username: userAltName,
            avatar_url: avatar_url,
            position: position,
            scores: scores,
            is_me: isMe,
            user_ext_id: cleanExtUserId,
            crm_brand_id: crmBrandId.map { Lenient.truncate($0) },
            user_id: userId.map { Lenient.truncate($0) }
        )
    }

    func toTournamentMe() -> TTournamentMe {
        TTournamentMe(
            public_username: userAltName,
            avatar_url: avatar_url,
            position: position,
            scores: scores,
            user_ext_id: cleanExtUserId,
            crm_brand_id: crmBrandId.map { Lenient.truncate($0) },
            user_id: userId.map { Lenient.truncate($0) }
        )
    }
}

extension TournamentPrize {
    /**
     * Protocol prize row → public API prize: same fields, but the numeric activity
     * type becomes the name the public API documents.
     */
    func toTournamentPrize() -> TTournamentPrize {
        TTournamentPrize(
            name: name,
            description: description,
            image_url: image_url,
            place_from: place_from,
            place_to: place_to,
            type: prizeTypeName(type),
            points: points
        )
    }
}

private func prizeTypeName(_ type: Int64?) -> String? {
    switch type {
    case ActivityTypeLimited.DoNothing: return "TANGIBLE"
    case ActivityTypeLimited.Points: return "POINTS_ADD"
    case ActivityTypeLimited.DeductPoints: return "POINTS_DEDUCT"
    case ActivityTypeLimited.ResetPoints: return "POINTS_RESET"
    case ActivityTypeLimited.MiniGameAttempt: return "MINI_GAME_ATTEMPT"
    case ActivityTypeLimited.Bonus: return "BONUS"
    case ActivityTypeLimited.AddGemsAndDiamonds: return "GEMS_AND_DIAMONDS_ADD"
    case ActivityTypeLimited.DeductGemsAndDiamonds: return "GEMS_AND_DIAMONDS_DEDUCT"
    case ActivityTypeLimited.ResetGemsAndDiamonds: return "GEMS_AND_DIAMONDS_RESET"
    default: return nil
    }
}

extension Optional where Wrapped == JSON {
    /**
     * Inline JSON arrays the protocol still hands over untyped → typed list.
     * The element type comes from context or is passed: `decodeList()` /
     * `decodeList(TournamentPlayer.self)`. `nil` when absent or not decodable.
     */
    func decodeList<T: Decodable>(_ type: T.Type = T.self) -> [T]? {
        guard let j = self else { return nil }
        return j.decodeList(type)
    }

    /** Same, for a single inline object. */
    func decodeObject<T: Decodable>(_ type: T.Type = T.self) -> T? {
        guard let j = self else { return nil }
        return j.decodeObject(type)
    }
}

extension JSON {
    /** Inline JSON arrays the protocol still hands over untyped → typed list. */
    func decodeList<T: Decodable>(_ type: T.Type = T.self) -> [T]? {
        try? apiDecoder.decode([T].self, from: data(sortedKeys: false))
    }

    /** Same, for a single inline object. */
    func decodeObject<T: Decodable>(_ type: T.Type = T.self) -> T? {
        try? apiDecoder.decode(T.self, from: data(sortedKeys: false))
    }
}

private func registrationTypeName(_ type: Int64?) -> String {
    switch type {
    case TournamentRegistrationType.AUTO: return "AUTO"
    case TournamentRegistrationType.OPT_IN: return "OPT_IN"
    case TournamentRegistrationType.BUY_IN_POINTS: return "BUY_IN_POINTS"
    case TournamentRegistrationType.MANUAL_APPROVAL: return "MANUAL_APPROVAL"
    case TournamentRegistrationType.REQUIRES_QUALIFICATION: return "REQUIRES_QUALIFICATION"
    case TournamentRegistrationType.BUY_IN_GEMS: return "BUY_IN_GEMS"
    case TournamentRegistrationType.BUY_IN_DIAMONDS: return "BUY_IN_DIAMONDS"
    default: return "UNKNOWN"
    }
}

/**
 * The server only sets `tournamentRegistrationStatus` when a registration row
 * exists for this user; for everyone else it ships as `null` — the wire has NO
 * value for "not registered" (`NOT_REGISTERED = 0` is a client-side sentinel
 * that never arrives). So an unregistered user legitimately gets "UNKNOWN"
 * here, by design. Read `is_user_registered` (always present)
 * when you need a reliable registered/not signal.
 */
private func registrationStatusName(_ status: Int64?) -> String {
    switch status {
    case TournamentRegistrationStatus.CANCELLED: return "CANCELLED"
    case TournamentRegistrationStatus.FINISHED: return "FINISHED"
    case TournamentRegistrationStatus.NOT_REGISTERED: return "NOT_REGISTERED"
    case TournamentRegistrationStatus.PENDING: return "PENDING"
    case TournamentRegistrationStatus.QUALIFIED_PENDING_REGISTRATION: return "QUALIFIED_PENDING_REGISTRATION"
    case TournamentRegistrationStatus.REGISTERED: return "REGISTERED"
    case TournamentRegistrationStatus.REGISTERED_PENDING_QUALIFICATION: return "REGISTERED_PENDING_QUALIFICATION"
    default: return "UNKNOWN"
    }
}
