// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Asks for the label's widget disclaimer ("additional T&C") text with any
/// personalisation placeholders already resolved for the current player.
///
/// Requires an identified session — the text is resolved against the player's
/// own state, so it cannot be requested before identification.
public struct TermsAndConditionsRequest: Codable, Hashable, Sendable {
    public var cid: Double?
    public var ts: Double?
    public var uuid: String?
    /// Overrides the session language used to resolve the text. Defaults to the player's language.
    public var force_language: String?

    public init(
        cid: Double? = nil,
        ts: Double? = nil,
        uuid: String? = nil,
        force_language: String? = nil
    ) {
        self.cid = cid
        self.ts = ts
        self.uuid = uuid
        self.force_language = force_language
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.cid = try c.lenientDouble("cid")
        self.ts = try c.lenientDouble("ts")
        self.uuid = try c.lenientString("uuid")
        self.force_language = try c.lenientString("force_language")
    }
}
// Inherited fields from ProtocolMessage are flattened above.
