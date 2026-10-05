// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RaffleDraw: Codable, Hashable, Sendable {
    /// Id of the Draw definition, for the repetative draws (e.g. daily), this number will be the same for all draws that are repeating daily
    /// (internal name: schedule_id)
    public var draw_id: Int64?
    /// Meta information of the Draw for the presentaiton in UI
    public var public_meta: RaffleDrawPublicMeta?
    /// Information about prizes in the draw
    public var prizes: [RafflePrize]?
    /// State of current instance of Draw
    public var current_state: Int64?
    /// Field indicates the ID of the latest instance/run of draw
    public var run_id: Int64?
    /// Type of the draw execution, indicating how and when the draw is executed.
    ///
    /// - ExecDate: Draw is executed only once at a specific date and time.
    /// - Recurring: Draw is executed on a recurring basis (e.g., daily, weekly).
    /// - Grand: Draw is executed once and is marked as grand, often with larger prizes or more importance.
    public var execution_type: Int64?
    /// Date/time of the draw execution
    public var execution_ts: Int64?
    /// Date of the previously executed draw (if there is such)
    public var previous_run_ts: Int64?
    /// Unique ID of the previusly executed draw (if there is such)
    public var previous_run_id: Int64?
    /// Date/time starting from which the tickets will participate in the upcoming draw
    /// This value need to be taken into account with next_execute_ts field value, for example
    /// Next draw is at 10:00, ticket_start_date is 9:00, so all tickets that are collected after 9:00 will participate in the draw at 10:00
    /// (internally this value is calculated as next_execute_ts - ticket_start_date)
    public var ticket_start_ts: Int64?
    /// Field is indicating if same ticket can win multiple prizes in the same draw
    /// For example there are 3 types of prizes in the draw - iPhone, iPad, MacBook
    /// If this field is true, then one ticket can win all 3 prizes (depending on the chances of course),
    /// if false, then one ticket can win only one prize.
    /// The distribution of the prizes is start from top (assuming on top are the most valuable prizes) to bottom (less valuable prizes)
    /// If specific prize has multiple values, e.g. we have 3 iPhones,
    /// then the same ticket can win only one prize of a kind, but can win multiple prizes of different kind (if allow_multi_prize_per_ticket is true)
    public var allow_multi_prize_per_ticket: Bool?
    /// The number of tickets that are already given to all users for this instance of draw.
    /// In other words tickets that are collected between ticket_start_date and current time (or till current_execution_ts is the instance is executed).
    public var total_tickets_count: Int64?
    /// The number of tickets collected by current user for this instance of draw.
    public var my_tickets_count: Int64?
    /// List of last 5 tickets are collected by current user for this instance of draw.
    public var my_last_tickets: [RaffleTicket]?
    /// If true, the user has opted-in to the raffle.
    public var user_opted_in: Bool?
    /// If true, the user needs to opt-in to the raffle before they can participate.
    public var requires_optin: Bool?
    /// If true, the draw is active and can be participated in.
    public var is_active: Bool?
    /// The number of winners to return
    public var winners_limit: Double?
    /// The offset of the winners to return
    public var winners_offset: Double?
    /// The total number of winners
    public var winners_total: Double?

    public init(
        draw_id: Int64? = nil,
        public_meta: RaffleDrawPublicMeta? = nil,
        prizes: [RafflePrize]? = nil,
        current_state: Int64? = nil,
        run_id: Int64? = nil,
        execution_type: Int64? = nil,
        execution_ts: Int64? = nil,
        previous_run_ts: Int64? = nil,
        previous_run_id: Int64? = nil,
        ticket_start_ts: Int64? = nil,
        allow_multi_prize_per_ticket: Bool? = nil,
        total_tickets_count: Int64? = nil,
        my_tickets_count: Int64? = nil,
        my_last_tickets: [RaffleTicket]? = nil,
        user_opted_in: Bool? = nil,
        requires_optin: Bool? = nil,
        is_active: Bool? = nil,
        winners_limit: Double? = nil,
        winners_offset: Double? = nil,
        winners_total: Double? = nil
    ) {
        self.draw_id = draw_id
        self.public_meta = public_meta
        self.prizes = prizes
        self.current_state = current_state
        self.run_id = run_id
        self.execution_type = execution_type
        self.execution_ts = execution_ts
        self.previous_run_ts = previous_run_ts
        self.previous_run_id = previous_run_id
        self.ticket_start_ts = ticket_start_ts
        self.allow_multi_prize_per_ticket = allow_multi_prize_per_ticket
        self.total_tickets_count = total_tickets_count
        self.my_tickets_count = my_tickets_count
        self.my_last_tickets = my_last_tickets
        self.user_opted_in = user_opted_in
        self.requires_optin = requires_optin
        self.is_active = is_active
        self.winners_limit = winners_limit
        self.winners_offset = winners_offset
        self.winners_total = winners_total
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.draw_id = try c.lenientInt64("draw_id")
        self.public_meta = try c.lenientObject(RaffleDrawPublicMeta.self, "public_meta")
        self.prizes = try c.lenientList(RafflePrize.self, "prizes")
        self.current_state = try c.lenientInt64("current_state")
        self.run_id = try c.lenientInt64("run_id")
        self.execution_type = try c.lenientInt64("execution_type")
        self.execution_ts = try c.lenientInt64("execution_ts")
        self.previous_run_ts = try c.lenientInt64("previous_run_ts")
        self.previous_run_id = try c.lenientInt64("previous_run_id")
        self.ticket_start_ts = try c.lenientInt64("ticket_start_ts")
        self.allow_multi_prize_per_ticket = try c.lenientBool("allow_multi_prize_per_ticket")
        self.total_tickets_count = try c.lenientInt64("total_tickets_count")
        self.my_tickets_count = try c.lenientInt64("my_tickets_count")
        self.my_last_tickets = try c.lenientList(RaffleTicket.self, "my_last_tickets")
        self.user_opted_in = try c.lenientBool("user_opted_in")
        self.requires_optin = try c.lenientBool("requires_optin")
        self.is_active = try c.lenientBool("is_active")
        self.winners_limit = try c.lenientDouble("winners_limit")
        self.winners_offset = try c.lenientDouble("winners_offset")
        self.winners_total = try c.lenientDouble("winners_total")
    }
}
