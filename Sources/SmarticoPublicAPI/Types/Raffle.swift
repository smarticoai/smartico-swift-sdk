// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct Raffle: Codable, Hashable, Sendable {
    /// ID of the Raffle template
    public var raffle_id: Int64?
    /// Meta information about raffle for the presentation on UI
    public var public_meta: RafflePublicMeta?
    /// Date of start
    public var start_date_ts: Int64?
    /// Date of end
    public var end_date_ts: Int64?
    /// Maximum numer of tickets that can be given to all users for the whole period of raffle
    public var max_tickets_count: Int64?
    /// Number of tickets that are already given to all users for this raffle
    public var current_tickets_count: Int64?
    /// List of draws that are available for this raffle.
    /// For example, if the raffle is containg one hourly draw, one daily draw and one draw on fixed date like 01/01/2022,
    /// Then the list will always return 3 draws, no matter if the draws are already executed or they are in the future.
    public var draws: [RaffleDraw]?

    public init(
        raffle_id: Int64? = nil,
        public_meta: RafflePublicMeta? = nil,
        start_date_ts: Int64? = nil,
        end_date_ts: Int64? = nil,
        max_tickets_count: Int64? = nil,
        current_tickets_count: Int64? = nil,
        draws: [RaffleDraw]? = nil
    ) {
        self.raffle_id = raffle_id
        self.public_meta = public_meta
        self.start_date_ts = start_date_ts
        self.end_date_ts = end_date_ts
        self.max_tickets_count = max_tickets_count
        self.current_tickets_count = current_tickets_count
        self.draws = draws
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.raffle_id = try c.lenientInt64("raffle_id")
        self.public_meta = try c.lenientObject(RafflePublicMeta.self, "public_meta")
        self.start_date_ts = try c.lenientInt64("start_date_ts")
        self.end_date_ts = try c.lenientInt64("end_date_ts")
        self.max_tickets_count = try c.lenientInt64("max_tickets_count")
        self.current_tickets_count = try c.lenientInt64("current_tickets_count")
        self.draws = try c.lenientList(RaffleDraw.self, "draws")
    }
}
