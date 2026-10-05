// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct RafflePrizeWinner: Codable, Hashable, Sendable {
    public var user_id: Int64?
    public var public_username: String?
    public var avatar_id: String?
    public var avatar_url: String?
    public var ticket: RaffleTicket?
    public var raf_won_id: Int64?
    public var claimed_date: Int64?

    public init(
        user_id: Int64? = nil,
        public_username: String? = nil,
        avatar_id: String? = nil,
        avatar_url: String? = nil,
        ticket: RaffleTicket? = nil,
        raf_won_id: Int64? = nil,
        claimed_date: Int64? = nil
    ) {
        self.user_id = user_id
        self.public_username = public_username
        self.avatar_id = avatar_id
        self.avatar_url = avatar_url
        self.ticket = ticket
        self.raf_won_id = raf_won_id
        self.claimed_date = claimed_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.user_id = try c.lenientInt64("user_id")
        self.public_username = try c.lenientString("public_username")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_url = try c.lenientString("avatar_url")
        self.ticket = try c.lenientObject(RaffleTicket.self, "ticket")
        self.raf_won_id = try c.lenientInt64("raf_won_id")
        self.claimed_date = try c.lenientInt64("claimed_date")
    }
}
