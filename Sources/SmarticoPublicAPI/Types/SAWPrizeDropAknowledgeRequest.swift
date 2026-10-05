// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct SAWPrizeDropAknowledgeRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var request_id: String?
    public var pending_message_id: Int64?
    public var claim_required: Bool?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        request_id: String? = nil,
        pending_message_id: Int64? = nil,
        claim_required: Bool? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.request_id = request_id
        self.pending_message_id = pending_message_id
        self.claim_required = claim_required
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.request_id = try c.lenientString("request_id")
        self.pending_message_id = try c.lenientInt64("pending_message_id")
        self.claim_required = try c.lenientBool("claim_required")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
