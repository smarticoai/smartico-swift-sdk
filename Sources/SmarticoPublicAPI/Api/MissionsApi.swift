import Foundation

extension SmarticoApi {
    /**
     * Missions and badges. Both live in the same server map (cid 502) and are told
     * apart by `ach_type_id`; badges additionally get their time-limit state
     * computed client-side.
     */
    public func getMissions() async throws -> [TMissionOrBadge] {
        (try await achievementMap().achievements ?? [])
            .filter { $0.ach_type_id == AchievementType.Mission }
            .toTMissions()
    }

    /** Badges: same map, filtered to badges, with `badgeTimeLimitState` filled in. */
    public func getBadges() async throws -> [TMissionOrBadge] {
        (try await achievementMap().achievements ?? [])
            .filter { $0.ach_type_id == AchievementType.Badge }
            .map { badge -> UserAchievement in
                // Only time-boxed badges carry a state.
                if badge.active_from_ts != nil || badge.active_till_ts != nil {
                    var b = badge
                    b.badgeTimeLimitState = determineBadgeState(badge)
                    return b
                } else {
                    return badge
                }
            }
            .toTMissions()
    }

    private func achievementMap() async throws -> GetAchievementMapResponse {
        try await call(
            cid: ClassId.GET_ACHIEVEMENT_MAP_REQUEST,
            expectCid: ClassId.GET_ACHIEVEMENT_MAP_RESPONSE,
            GetAchievementMapResponse.self
        )
    }
}

extension Optional where Wrapped: RangeReplaceableCollection {
    /** Kotlin's `orEmpty()`: the collection, or an empty one for `nil`. Shared by every Api file. */
    func orEmpty() -> Wrapped { self ?? Wrapped() }
}

extension Array where Element == UserAchievement {
    /**
     * Wire shape → public shape. Display fields come out of `ach_public_meta`,
     * tasks are filtered to the progress-bearing type, and recurrence/availability
     * are derived.
     *
     * NOT supported yet: `{{suggested_*}}` tag substitution in name/sub_header/
     * description — an operator feature for "play your favourite game" missions;
     * the raw template text is returned as-is until it lands.
     */
    func toTMissions() -> [TMissionOrBadge] {
        filter { ($0.ach_id ?? 0) >= 1 }.map { r -> TMissionOrBadge in
            let meta = r.ach_public_meta
            let tasks: [TMissionOrBadgeTask] = (r.achievementTasks ?? [])
                .filter { $0.task_type_id == AchievementTaskType.CompleteAchievement }
                .map { t in
                    TMissionOrBadgeTask(
                        id: t.task_id,
                        name: t.task_public_meta?.name,
                        is_completed: t.isCompleted,
                        progress: t.userProgress,
                        points_reward: t.points_reward,
                        gems_reward: t.gems_reward,
                        diamonds_reward: t.diamonds_reward,
                        execution_count_expected: t.executionCount.map { Double($0) },
                        execution_count_actual: t.userExecutedCount.map { Double($0) },
                        display_progress_as_count: t.task_public_meta?.display_progress_as_count,
                        stage_image: t.task_public_meta?.stage_image,
                        priority: t.task_public_meta?.priority ?? 0
                    )
                }
            // Related games are exposed with a display-ordered priority and
            // without the internal ach_game_id.
            let relatedGames: [AchRelatedGame] = (r.related_games ?? []).enumerated().map { i, g in
                var game = g
                game.ach_game_id = nil
                game.game_public_meta = g.game_public_meta?.object.map { meta -> JSON in
                    var out = JSONObject()
                    for key in ["name", "link", "image", "enabled", "game_categories", "game_provider", "mobile_spec_link"] {
                        if let v = meta[key] { out[key] = v }
                    }
                    out["priority"] = JSON(i + 1)
                    return .object(out)
                }
                return game
            }
            // "custom" means the operator typed their own ribbon text
            let ribbonText = meta?.label_tag == "custom" ? meta?.custom_label_tag : meta?.label_tag
            let ribbon: JSON? = ribbonText.map { JSON.string($0) }
            var base = TMissionOrBadge(
                id: r.ach_id,
                type: r.ach_type_id == AchievementType.Mission ? "mission" : "badge",
                name: meta?.name,
                sub_header: meta?.sub_header,
                description: meta?.description,
                reward: meta?.reward,
                image: meta?.image_url,
                is_completed: r.isCompleted,
                is_locked: r.isLocked,
                unlock_mission_description: meta?.unlock_mission_description,
                is_requires_optin: r.requiresOptin,
                is_opted_in: r.isOptedIn,
                time_limit_ms: r.time_limit_ms,
                active_from_ts: r.active_from_ts,
                active_till_ts: r.active_till_ts,
                dt_start: r.start_date_ts,
                progress: r.progress,
                cta_action: meta?.cta_action,
                cta_text: meta?.cta_text,
                custom_section_id: meta?.custom_section_id,
                only_in_custom_section: meta?.only_in_custom_section,
                custom_data: jsonOrText(meta?.custom_data),
                tasks: tasks,
                related_games: relatedGames,
                category_ids: r.ach_categories?.map { Lenient.truncate($0) },
                hint_text: meta?.hint_text,
                position: meta?.position,
                ribbon: ribbon,
                ach_completed_id: r.ach_completed_id,
                requires_prize_claim: r.requires_prize_claim,
                prize_claimed_date_ts: r.prize_claimed_date_ts,
                complete_date: r.complete_date,
                complete_date_ts: r.complete_date_ts,
                completed_today: r.complete_date_ts.map { isWithinPeriod($0, .TODAY) } ?? false,
                completed_this_week: r.complete_date_ts.map { isWithinPeriod($0, .THIS_WEEK) } ?? false,
                completed_this_month: r.complete_date_ts.map { isWithinPeriod($0, .THIS_MONTH) } ?? false,
                custom_section_type_id: meta?.custom_section_type_id,
                availability_status: availabilityStatus(r),
                claim_button_title: meta?.claim_button_title,
                claim_button_action: meta?.claim_button_action,
                prize_claim_expiration_date: r.prize_claim_expiration_date,
                prize_claim_period_type_id: r.prize_claim_period_type_id,
                badgeTimeLimitState: r.badgeTimeLimitState,
                hide_locked_mission: meta?.hide_locked_mission
            )
            switch r.ach_status_id {
            case AchievementStatus.Recurring:
                base.next_recurrence_date_ts = nowMs() + (r.milliseconds_till_available ?? 0)
            case AchievementStatus.RecurringUponCompletion:
                base.completion_count = r.completed_count
                base.max_completion_count = r.recurring_quantity.map { Lenient.truncate($0) }
            default:
                break
            }
            return base
        }
    }
}

/** custom_data that is already a JSON element; absent becomes an empty object. */
func jsonOrText(_ raw: JSON?) -> JSON { raw ?? .object([:]) }

/**
 * Operator custom_data holds either JSON or plain text — surface both as JSON.
 * Empty input becomes an empty object, so callers never have to special-case
 * "no custom data".
 */
func jsonOrText(_ raw: String?) -> JSON {
    guard let raw = raw, !raw.isEmpty else { return .object([:]) }
    if raw.contains("{") || raw.contains("[") {
        if let parsed = try? JSON.parse(raw) { return parsed }
    }
    return .string(raw)
}

enum Period { case TODAY, THIS_WEEK, THIS_MONTH }

/**
 * Local-calendar comparison: same day / week / month as right now.
 * `now` is a test seam (Kotlin reads the clock inline); callers omit it.
 */
func isWithinPeriod(_ timestamp: Int64, _ period: Period, now: Date = Date()) -> Bool {
    let cal = Calendar.current
    let then = Date(timeIntervalSince1970: Double(timestamp) / 1000)
    let n = cal.dateComponents([.year, .month, .day], from: now)
    let t = cal.dateComponents([.year, .month, .day], from: then)
    let sameYear = n.year == t.year
    let sameMonth = sameYear && n.month == t.month
    switch period {
    case .TODAY:
        return sameMonth && n.day == t.day
    case .THIS_MONTH:
        return sameMonth
    case .THIS_WEEK:
        // Weeks start on Sunday, matching how the server groups them.
        // (`.weekday` is 1 for Sunday in every locale; `firstWeekday` is not consulted.)
        let weekday = cal.component(.weekday, from: now)
        guard let shifted = cal.date(byAdding: .day, value: -(weekday - 1), to: now),
              let lastDay = cal.date(byAdding: .day, value: 6, to: cal.startOfDay(for: shifted)),
              let endOfWeek = cal.date(bySettingHour: 23, minute: 59, second: 59, of: lastDay)
        else { return false }
        let startOfWeek = cal.startOfDay(for: shifted)
        let startMs = Int64((startOfWeek.timeIntervalSince1970 * 1000).rounded())
        let endMs = Int64((endOfWeek.timeIntervalSince1970 * 1000).rounded()) + 999
        return timestamp >= startMs && timestamp <= endMs
    }
}

/** Badge time-limit state: not started yet, running, or expired. */
func determineBadgeState(_ badge: UserAchievement) -> Int64? {
    let now = nowMs()
    let from = badge.active_from_ts
    let till = badge.active_till_ts
    let progress = badge.progress ?? 0.0
    // completed in time → no state chip at all
    if badge.isCompleted == true && (till.map { (badge.complete_date_ts ?? 0) < $0 } ?? true) { return nil }
    if let from = from, from > now { return BadgesTimeLimitStates.BeforeStartDate }
    guard let till = till else {
        if progress == 0.0 {
            return BadgesTimeLimitStates.AfterStartDateNoProgress
        } else {
            // An open-ended badge with progress is still earnable; it has its
            // own state so a UI never renders it as expired.
            return BadgesTimeLimitStates.AfterStartDateWithProgress
        }
    }
    if now < till {
        return progress == 0.0
            ? BadgesTimeLimitStates.AfterStartDateNoProgressAndEndDate
            : BadgesTimeLimitStates.AfterStartDateWithProgressAndEndDate
    }
    return progress == 0.0
        ? BadgesTimeLimitStates.AfterEndDateNotStarted
        : BadgesTimeLimitStates.AfterEndDateWithProgress
}

/**
 * Availability state machine: combines the active window, the optional time
 * limit, opt-in and lock state into the single status a UI renders from.
 */
func availabilityStatus(_ m: UserAchievement) -> Int64? {
    let now = nowMs()
    let activeFrom = m.active_from_ts
    let activeTill = m.active_till_ts
    let startDate = m.start_date_ts ?? 0
    let timeLimit = m.time_limit_ms ?? 0
    let requiresOptIn = m.requiresOptin == true
    let optedIn = m.isOptedIn == true
    let isLockedMission = m.ach_status_id == AchievementStatus.AvailableLocked
    let isLocked = m.isLocked == true

    /** The shared "gate" every branch below applies. */
    func gated(_ active: Int64, _ inactive: Int64, _ plain: Int64) -> Int64 {
        if requiresOptIn { return optedIn ? active : inactive }
        if isLockedMission { return !isLocked ? active : inactive }
        return plain
    }

    if activeFrom == nil && activeTill == nil && timeLimit == 0 {
        return gated(
            AchievementAvailabilityStatus.AvailableActive,
            AchievementAvailabilityStatus.AvailableInactive,
            AchievementAvailabilityStatus.Available
        )
    }
    if let activeFrom = activeFrom, activeFrom > now {
        return AchievementAvailabilityStatus.UnavailableWithActiveFrom
    }

    // from here: the window has started (or was never bounded from the left)
    if activeTill == nil && timeLimit == 0 {
        return gated(
            AchievementAvailabilityStatus.AvailableActive,
            AchievementAvailabilityStatus.AvailableInactive,
            AchievementAvailabilityStatus.Available
        )
    }
    if let activeTill = activeTill, timeLimit == 0 {
        if activeTill <= now { return AchievementAvailabilityStatus.MissedByActiveTill }
        return gated(
            AchievementAvailabilityStatus.AvailableWithActiveTillActive,
            AchievementAvailabilityStatus.AvailableWithActiveTillInactive,
            AchievementAvailabilityStatus.AvailableWithActiveTill
        )
    }
    // NOTE the asymmetry — it is deliberate, not a slip: only the PLAIN branch
    // lets a later active_from push the deadline out, while the opt-in and
    // locked branches always measure the limit from start_date. Collapsing that
    // into one shared endDate makes some missions report the wrong status.
    if timeLimit > 0 && activeTill == nil {
        let plainEnd = (activeFrom.flatMap { $0 > startDate ? $0 : nil } ?? startDate) + timeLimit
        if requiresOptIn {
            if !optedIn { return AchievementAvailabilityStatus.AvailableLimitedInactive }
            else if startDate + timeLimit > now { return AchievementAvailabilityStatus.AvailableLimitedActive }
            else { return AchievementAvailabilityStatus.MissedByLimitInTime }
        }
        if isLockedMission {
            if isLocked { return AchievementAvailabilityStatus.AvailableLimitedInactive }
            else if startDate + timeLimit > now { return AchievementAvailabilityStatus.AvailableLimitedActive }
            else { return AchievementAvailabilityStatus.MissedByLimitInTime }
        }
        return plainEnd > now
            ? AchievementAvailabilityStatus.AvailableLimited
            : AchievementAvailabilityStatus.MissedByLimitInTime
    }
    if timeLimit > 0, let activeTill = activeTill {
        if activeTill <= now { return AchievementAvailabilityStatus.MissedByActiveTill }
        let plainEnd = (activeFrom.flatMap { $0 > startDate ? $0 : nil } ?? startDate) + timeLimit
        if requiresOptIn {
            if !optedIn { return AchievementAvailabilityStatus.AvailableFullyLimitedInactive }
            else if startDate + timeLimit > now { return AchievementAvailabilityStatus.AvailableFullyLimitedActive }
            else { return AchievementAvailabilityStatus.MissedByLimitInTime }
        }
        if isLockedMission {
            if isLocked { return AchievementAvailabilityStatus.AvailableFullyLimitedInactive }
            else if startDate + timeLimit > now { return AchievementAvailabilityStatus.AvailableFullyLimitedActive }
            else { return AchievementAvailabilityStatus.MissedByLimitInTime }
        }
        return plainEnd > now
            ? AchievementAvailabilityStatus.AvailableFullyLimited
            : AchievementAvailabilityStatus.MissedByLimitInTime
    }
    return nil
}
