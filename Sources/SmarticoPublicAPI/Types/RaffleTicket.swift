// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RaffleTicket: Codable, Hashable, Sendable {
    /// Int presentation of the ticket
    public var id: Int64?
    /// String presentation of the ticket
    public var s: String?

    public init(
        id: Int64? = nil,
        s: String? = nil
    ) {
        self.id = id
        self.s = s
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.s = try c.lenientString("s")
    }
}
