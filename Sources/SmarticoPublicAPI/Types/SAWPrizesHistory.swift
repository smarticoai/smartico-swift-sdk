// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWPrizesHistory: Codable, Hashable, Sendable {
    public var template: SAWTemplate?
    public var saw_template_id: Int64?
    public var saw_prize_id: Int64?
    public var prize_amount: Double?
    public var client_request_id: String?
    public var is_claimed: Bool?
    public var create_date_ts: Int64?
    public var acknowledge_date_ts: Int64?

    public init(
        template: SAWTemplate? = nil,
        saw_template_id: Int64? = nil,
        saw_prize_id: Int64? = nil,
        prize_amount: Double? = nil,
        client_request_id: String? = nil,
        is_claimed: Bool? = nil,
        create_date_ts: Int64? = nil,
        acknowledge_date_ts: Int64? = nil
    ) {
        self.template = template
        self.saw_template_id = saw_template_id
        self.saw_prize_id = saw_prize_id
        self.prize_amount = prize_amount
        self.client_request_id = client_request_id
        self.is_claimed = is_claimed
        self.create_date_ts = create_date_ts
        self.acknowledge_date_ts = acknowledge_date_ts
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.template = try c.lenientObject(SAWTemplate.self, "template")
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.saw_prize_id = try c.lenientInt64("saw_prize_id")
        self.prize_amount = try c.lenientDouble("prize_amount")
        self.client_request_id = try c.lenientString("client_request_id")
        self.is_claimed = try c.lenientBool("is_claimed")
        self.create_date_ts = try c.lenientInt64("create_date_ts")
        self.acknowledge_date_ts = try c.lenientInt64("acknowledge_date_ts")
    }
}
