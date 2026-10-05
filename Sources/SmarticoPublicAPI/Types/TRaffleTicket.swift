// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TRaffleTicket: Codable, Hashable, Sendable {
    /// Int presentation of the ticket
    public var ticekt_id: Int64?
    /// String presentation of the ticket
    public var ticket_id_string: String?

    public init(
        ticekt_id: Int64? = nil,
        ticket_id_string: String? = nil
    ) {
        self.ticekt_id = ticekt_id
        self.ticket_id_string = ticket_id_string
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ticekt_id = try c.lenientInt64("ticekt_id")
        self.ticket_id_string = try c.lenientString("ticket_id_string")
    }
}
