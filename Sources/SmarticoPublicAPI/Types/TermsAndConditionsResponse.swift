// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// The label's widget disclaimer ("additional T&C") text, resolved for the
/// current player.
///
/// The value is the configured disclaimer with its personalisation placeholders
/// substituted. Placeholders that cannot be resolved are left as-is rather than
/// blanked. May be `null` or an empty string when no disclaimer is configured,
/// in which case nothing should be rendered. The text may contain HTML.
public struct TermsAndConditionsResponse: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    public var errCode: Int64?
    public var errMsg: String?
    /// The resolved disclaimer text, or `null` / `''` when none is configured.
    public var widget_disclaimer_text: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        errCode: Int64? = nil,
        errMsg: String? = nil,
        widget_disclaimer_text: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.errCode = errCode
        self.errMsg = errMsg
        self.widget_disclaimer_text = widget_disclaimer_text
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.errCode = try c.lenientInt64("errCode")
        self.errMsg = try c.lenientString("errMsg")
        self.widget_disclaimer_text = try c.lenientString("widget_disclaimer_text")
    }
}
// Inherited fields from ProtocolResponse are flattened above.
