// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TRafflePrizeWinner: Codable, Hashable, Sendable {
    /// Id of the winner definition, for the repetative winners (e.g. same winner won two prizes), this number will be the same for all winner that are repeating
    /// (internal name: schedule_id)
    public var id: Int64?
    /// Winner user name
    public var username: String?
    /// URL of the image of user avatar
    public var avatar_url: String?
    /// Ticket information (number string and integer)
    public var ticket: TRaffleTicket?
    /// Unique ID of winning
    public var raf_won_id: Int64?
    /// Date when the prize was claimed
    public var claimed_date: Int64?

    public init(
        id: Int64? = nil,
        username: String? = nil,
        avatar_url: String? = nil,
        ticket: TRaffleTicket? = nil,
        raf_won_id: Int64? = nil,
        claimed_date: Int64? = nil
    ) {
        self.id = id
        self.username = username
        self.avatar_url = avatar_url
        self.ticket = ticket
        self.raf_won_id = raf_won_id
        self.claimed_date = claimed_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.username = try c.lenientString("username")
        self.avatar_url = try c.lenientString("avatar_url")
        self.ticket = try c.lenientObject(TRaffleTicket.self, "ticket")
        self.raf_won_id = try c.lenientInt64("raf_won_id")
        self.claimed_date = try c.lenientInt64("claimed_date")
    }
}
