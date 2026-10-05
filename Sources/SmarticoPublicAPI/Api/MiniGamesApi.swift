import Foundation

extension SmarticoApi {
    /** Mini-games (spin-a-wheel, scratch card, match-X, lootbox, …) available to the user. */
    public func getMiniGames() async throws -> [TMiniGameTemplate] {
        try await call(
            cid: ClassId.SAW_GET_SPINS_REQUEST,
            expectCid: ClassId.SAW_GET_SPINS_RESPONSE,
            SAWGetTemplatesResponse.self
        ).templates.orEmpty().toTMiniGames()
    }
}

/** Fallback thumbnail host, used when neither the template nor its skin defines one. */
private let SAW_ICON_CDN = "https://d312ucx3huj7iy.cloudfront.net/gf/images/saw"

extension Array where Element == SAWTemplate {
    func toTMiniGames() -> [TMiniGameTemplate] {
        map { r in
            let ui = r.saw_template_ui_definition
            let gameType = r.saw_game_type_id
            return TMiniGameTemplate(
                id: r.saw_template_id,
                name: ui?.name,
                description: ui?.description,
                // thumbnail → skin folder → CDN convention, in that order
                thumbnail: ui?.thumbnail.flatMap { $0.isEmpty ? nil : $0 }
                    ?? r.saw_skin_ui_definition?.object?["skin_folder"]?.string.flatMap { $0.isEmpty ? nil : "\($0)/ico.png" }
                    ?? "\(SAW_ICON_CDN)/\(r.saw_skin_key ?? "null")/ico.png",
                visibile_when_can_spin: r.visibile_when_can_spin,
                saw_game_type: sawGameTypeName(gameType),
                saw_buyin_type: sawBuyInTypeName(r.saw_buyin_type_id),
                // one wire field (buyin_cost_points) routed by the buy-in currency
                buyin_cost_points: r.saw_buyin_type_id == SAWBuyInType.Points ? r.buyin_cost_points : nil,
                buyin_cost_gems: r.saw_buyin_type_id == SAWBuyInType.Gems ? r.buyin_cost_points.map { Double($0) } : nil,
                buyin_cost_diamonds: r.saw_buyin_type_id == SAWBuyInType.Diamonds ? r.buyin_cost_points.map { Double($0) } : nil,
                spin_count: r.spin_count,
                next_available_spin_ts: r.next_available_spin_ts,
                earliest_expiration_dt: r.earliest_expiration_dt,
                latest_expiration_dt: r.latest_expiration_dt,
                over_limit_message: ui?.over_limit_message,
                no_attempts_message: ui?.no_attempts_message,
                jackpot_current: r.jackpot_current,
                jackpot_add_on_attempt: r.jackpot_add_on_attempt,
                jackpot_symbol: ui?.jackpot_symbol,
                promo_image: ui?.promo_image,
                promo_text: ui?.promo_text,
                custom_data: jsonOrText(ui?.custom_data),
                prizes: r.prizes.orEmpty().map { $0.toTMiniGamePrize() },
                expose_game_stat_on_api: r.expose_game_stat_on_api,
                relative_period_timezone: r.relative_period_timezone,
                activeFromDate: r.activeFromDate,
                activeTillDate: r.activeTillDate,
                steps_to_finish_game: ui?.steps_to_finish_game,
                min_steps_to_finish_game: ui?.min_steps_to_finish_game,
                custom_section_id: ui?.custom_section_id,
                saw_template_ui_definition: ui,
                // layout only means something for the calendar/weekday lootboxes
                game_layout: gameType == SAWGameType.LootboxCalendarDays || gameType == SAWGameType.LootboxWeekdays
                    ? sawGameLayoutName(ui?.game_layout)
                    : nil,
                show_prize_history: r.show_prize_history,
                max_number_of_attempts: r.maxSpinsCount.map { Double($0) },
                max_spins_period_ms: r.maxSpinsPediodMs.map { Lenient.truncate($0) }
            )
        }
    }
}

extension SAWPrize {
    func toTMiniGamePrize() -> TMiniGamePrize {
        let ui = saw_prize_ui_definition
        return TMiniGamePrize(
            id: saw_prize_id,
            name: ui?.name,
            prize_type: miniGamePrizeTypeName(prize_type_id),
            prize_value: prize_value,
            font_size: ui?.font_size,
            font_size_mobile: ui?.font_size_mobile,
            icon: ui?.icon,
            position: ui?.position,
            sectors: ui?.sectors,
            acknowledge_type: sawAcknowledgeTypeName(ui?.acknowledge_type),
            aknowledge_message: ui?.aknowledge_message,
            aknowledge_message_lose: ui?.aknowledge_message_lose,
            acknowledge_dp: ui?.acknowledge_dp,
            acknowledge_action_title: ui?.acknowledge_action_title,
            acknowledge_dp_additional: ui?.acknowledge_dp_additional,
            acknowledge_action_title_additional: ui?.acknowledge_action_title_additional,
            second_btn: ui?.second_btn,
            second_btn_action_title: ui?.second_btn_action_title,
            out_of_stock_message: ui?.out_of_stock_message,
            pool: pool,
            pool_initial: pool_initial,
            wins_count: wins_count,
            weekdays: weekdays,
            active_from_ts: active_from_ts,
            active_till_ts: active_till_ts,
            relative_period_timezone: relative_period_timezone,
            is_surcharge: is_surcharge,
            is_deleted: is_deleted,
            custom_data: jsonOrText(ui?.custom_data),
            prize_modifiers: ui?.prize_modifiers,
            hide_prize_from_history: ui?.hide_prize_from_history,
            requirements_to_get_prize: ui?.requirements_to_get_prize,
            max_give_period_type_id: max_give_period_type_id
        )
    }
}
