// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWPrizeDropWinPush: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var request_id: String?
    public var saw_template_id: Int64?
    public var saw_prize: SAWPrize?
    public var saw_template: SAWTemplate?
    public var pending_message_id: Int64?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        request_id: String? = nil,
        saw_template_id: Int64? = nil,
        saw_prize: SAWPrize? = nil,
        saw_template: SAWTemplate? = nil,
        pending_message_id: Int64? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.request_id = request_id
        self.saw_template_id = saw_template_id
        self.saw_prize = saw_prize
        self.saw_template = saw_template
        self.pending_message_id = pending_message_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.request_id = try c.lenientString("request_id")
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.saw_prize = try c.lenientObject(SAWPrize.self, "saw_prize")
        self.saw_template = try c.lenientObject(SAWTemplate.self, "saw_template")
        self.pending_message_id = try c.lenientInt64("pending_message_id")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
