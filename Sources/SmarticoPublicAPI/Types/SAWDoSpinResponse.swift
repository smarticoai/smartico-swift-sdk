// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWDoSpinResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    public var request_id: String?
    public var saw_prize_id: Int64?
    public var jackpot_amount: Double?
    public var first_spin_in_period: Double?
    public var visitor_win_uuid: String?
    public var spin_id: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        request_id: String? = nil,
        saw_prize_id: Int64? = nil,
        jackpot_amount: Double? = nil,
        first_spin_in_period: Double? = nil,
        visitor_win_uuid: String? = nil,
        spin_id: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.request_id = request_id
        self.saw_prize_id = saw_prize_id
        self.jackpot_amount = jackpot_amount
        self.first_spin_in_period = first_spin_in_period
        self.visitor_win_uuid = visitor_win_uuid
        self.spin_id = spin_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.request_id = try c.lenientString("request_id")
        self.saw_prize_id = try c.lenientInt64("saw_prize_id")
        self.jackpot_amount = try c.lenientDouble("jackpot_amount")
        self.first_spin_in_period = try c.lenientDouble("first_spin_in_period")
        self.visitor_win_uuid = try c.lenientString("visitor_win_uuid")
        self.spin_id = try c.lenientInt64("spin_id")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
