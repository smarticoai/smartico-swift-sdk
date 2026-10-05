// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Live jackpot-win notification. Delivered both to the winner and to other players
/// taking part in the same jackpot — use `winners[].is_me` to tell the two apart;
/// the copy sent to other players has its `public_username` masked.
///
/// Surfaced to consumers through the `jackpot_win` callback
/// (`Smartico.on('jackpot_win', …)`).
///
/// The explosion time is `jackpot.pot.explode_date_ts` (epoch milliseconds).
public struct JackpotWinPush: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    /// The jackpot that exploded, including its live `pot` snapshot
    public var jackpot: JackpotDetails?
    /// Winner entries; currently always a single entry
    public var winners: [JackPotWinPushWinner]?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        jackpot: JackpotDetails? = nil,
        winners: [JackPotWinPushWinner]? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.jackpot = jackpot
        self.winners = winners
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.jackpot = try c.lenientObject(JackpotDetails.self, "jackpot")
        self.winners = try c.lenientList(JackPotWinPushWinner.self, "winners")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
