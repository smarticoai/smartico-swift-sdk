import Foundation

extension SmarticoApi {
    /** Raffles: each raffle holds draws, each draw holds prizes and the user's tickets. */
    public func getRaffles() async throws -> [TRaffle] {
        (try await call(
            cid: ClassId.RAF_GET_RAFFLES_REQUEST,
            expectCid: ClassId.RAF_GET_RAFFLES_RESPONSE,
            GetRafflesResponse.self
        ).items ?? []).toTRaffles()
    }
}

extension Array where Element == Raffle {
    func toTRaffles() -> [TRaffle] {
        map { item in
            let meta = item.public_meta
            return TRaffle(
                id: item.raffle_id,
                name: meta?.name,
                description: meta?.description,
                custom_section_id: meta?.custom_section_id,
                image_url: meta?.image_url,
                image_url_mobile: meta?.image_url_mobile,
                hint_text: meta?.hint_text,
                custom_data: meta?.custom_data,
                start_date: item.start_date_ts,
                end_date: item.end_date_ts,
                max_tickets_count: item.max_tickets_count,
                current_tickets_count: item.current_tickets_count,
                draws: (item.draws ?? []).toTDraws(),
                ticket_cap_visualization: meta?.ticket_cap_visualization
            )
        }
    }
}

extension Array where Element == RaffleDraw {
    func toTDraws() -> [TRaffleDraw] {
        map { d in
            let meta = d.public_meta
            return TRaffleDraw(
                id: d.draw_id,
                name: meta?.name,
                description: meta?.description,
                image_url: meta?.image_url,
                image_url_mobile: meta?.image_url_mobile,
                icon_url: meta?.icon_url,
                background_image_url: meta?.background_image_url,
                background_image_url_mobile: meta?.background_image_url_mobile,
                is_grand: meta?.is_grand,
                prizes: (d.prizes ?? []).map { $0.toTPrize() },
                current_state: d.current_state,
                run_id: d.run_id,
                execution_type: d.execution_type,
                execution_ts: d.execution_ts,
                previous_run_ts: d.previous_run_ts,
                previous_run_id: d.previous_run_id,
                ticket_start_ts: d.ticket_start_ts,
                allow_multi_prize_per_ticket: d.allow_multi_prize_per_ticket,
                total_tickets_count: d.total_tickets_count,
                my_tickets_count: d.my_tickets_count,
                my_last_tickets: (d.my_last_tickets ?? []).map { $0.toTTicket() },
                // the wire sends these as loose values — normalise to real booleans
                user_opted_in: d.user_opted_in == true,
                requires_optin: d.requires_optin == true,
                is_active: d.is_active == true,
                winners_limit: d.winners_limit,
                winners_offset: d.winners_offset,
                winners_total: d.winners_total
            )
        }
    }
}

private extension RafflePrize {
    func toTPrize() -> TRafflePrize {
        let meta = public_meta
        return TRafflePrize(
            id: prize_id,
            name: meta?.name,
            description: meta?.description,
            image_url: meta?.image_url,
            custom_data: meta?.custom_data,
            hide_chance_to_win: meta?.hide_chance_to_win,
            prizes_per_run: prizes_per_run,
            prizes_per_run_actual: prizes_per_run_actual,
            chances_to_win_perc: chances_to_win_perc,
            min_required_total_tickets: min_required_total_tickets,
            requires_claim: requires_claim,
            min_required_tickets_for_user: min_required_tickets_for_user,
            cap_prizes_per_run: cap_prizes_per_run,
            priority: priority,
            stock_items_per_draw: stock_items_per_draw,
            should_claim: should_claim,
            winners: (winners ?? []).map { w in
                TRafflePrizeWinner(
                    id: w.user_id,
                    username: w.public_username,
                    avatar_url: w.avatar_url ?? w.avatar_id,
                    ticket: TRaffleTicket(ticekt_id: w.ticket?.id, ticket_id_string: w.ticket?.s),
                    raf_won_id: w.raf_won_id,
                    claimed_date: w.claimed_date
                )
            }
        )
    }
}

private extension RaffleTicket {
    /** The wire abbreviates ticket fields to `id`/`s`. */
    func toTTicket() -> TRaffleTicket { TRaffleTicket(ticekt_id: id, ticket_id_string: s) }
}
