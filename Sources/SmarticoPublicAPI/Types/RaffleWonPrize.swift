// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// A single prize the user won within the raffle.
public struct RaffleWonPrize: Codable, Hashable, Sendable {
    /// Unique ID of the winning row (pass to `claimRafflePrize` when `requires_claim` is `true`).
    public var raf_won_id: Int64?
    /// ID of the prize definition.
    public var prize_id: Int64?
    /// Run-instance ID of the draw that awarded this prize.
    public var raffle_run_id: Int64?
    /// Schedule ID of the draw that awarded this prize.
    public var draw_id: Int64?
    /// Presentation meta (name / image).
    public var public_meta: RaffleWonPrizePublicMeta?
    /// Whether this prize requires a claim action from the user.
    public var requires_claim: Bool?
    /// Epoch ms when the prize was claimed; `null` when not yet claimed.
    public var claimed_date: Int64?

    public init(
        raf_won_id: Int64? = nil,
        prize_id: Int64? = nil,
        raffle_run_id: Int64? = nil,
        draw_id: Int64? = nil,
        public_meta: RaffleWonPrizePublicMeta? = nil,
        requires_claim: Bool? = nil,
        claimed_date: Int64? = nil
    ) {
        self.raf_won_id = raf_won_id
        self.prize_id = prize_id
        self.raffle_run_id = raffle_run_id
        self.draw_id = draw_id
        self.public_meta = public_meta
        self.requires_claim = requires_claim
        self.claimed_date = claimed_date
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.raf_won_id = try c.lenientInt64("raf_won_id")
        self.prize_id = try c.lenientInt64("prize_id")
        self.raffle_run_id = try c.lenientInt64("raffle_run_id")
        self.draw_id = try c.lenientInt64("draw_id")
        self.public_meta = try c.lenientObject(RaffleWonPrizePublicMeta.self, "public_meta")
        self.requires_claim = try c.lenientBool("requires_claim")
        self.claimed_date = try c.lenientInt64("claimed_date")
    }
}
