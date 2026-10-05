// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RaffleDrawRun: Codable, Hashable, Sendable {
    /// Id of the Draw definition, for the repetative draws (e.g. daily), this number will be the same for all draws that are repeating daily
    /// (internal name: schedule_id)
    public var draw_id: Int64?
    /// Field indicates the ID of the latest instance/run of draw
    public var run_id: Int64?
    /// Meta information of the Draw for the presentaiton in UI
    public var public_meta: RaffleDrawPublicMeta?
    /// Date/time of the draw execution
    public var execution_ts: Int64?
    /// Actual Date/time of the draw execution
    public var actual_execution_ts: Int64?
    /// Date/time starting from which the tickets will participate in the upcoming draw
    ///  This value need to be taken into account with next_execute_ts field value, for example
    ///  Next draw is at 10:00, ticket_start_date is 9:00, so all tickets that are collected after 9:00 will participate in the draw at 10:00
    ///  (internally this value is calculated as next_execute_ts - ticket_start_date)
    public var ticket_start_ts: Int64?
    /// Shows if user has won a prize in a current run
    public var is_winner: Bool?
    /// Shows if user has unclaimed prize
    public var has_unclaimed_prize: Bool?

    public init(
        draw_id: Int64? = nil,
        run_id: Int64? = nil,
        public_meta: RaffleDrawPublicMeta? = nil,
        execution_ts: Int64? = nil,
        actual_execution_ts: Int64? = nil,
        ticket_start_ts: Int64? = nil,
        is_winner: Bool? = nil,
        has_unclaimed_prize: Bool? = nil
    ) {
        self.draw_id = draw_id
        self.run_id = run_id
        self.public_meta = public_meta
        self.execution_ts = execution_ts
        self.actual_execution_ts = actual_execution_ts
        self.ticket_start_ts = ticket_start_ts
        self.is_winner = is_winner
        self.has_unclaimed_prize = has_unclaimed_prize
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.draw_id = try c.lenientInt64("draw_id")
        self.run_id = try c.lenientInt64("run_id")
        self.public_meta = try c.lenientObject(RaffleDrawPublicMeta.self, "public_meta")
        self.execution_ts = try c.lenientInt64("execution_ts")
        self.actual_execution_ts = try c.lenientInt64("actual_execution_ts")
        self.ticket_start_ts = try c.lenientInt64("ticket_start_ts")
        self.is_winner = try c.lenientBool("is_winner")
        self.has_unclaimed_prize = try c.lenientBool("has_unclaimed_prize")
    }
}
