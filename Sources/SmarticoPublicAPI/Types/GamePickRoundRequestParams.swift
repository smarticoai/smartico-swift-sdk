// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickRoundRequestParams extends base params with a specific round ID
public struct GamePickRoundRequestParams: Codable, Hashable, Sendable {
    /// ID of the MatchX or Quiz game template. The only field the consumer supplies.
    public var saw_template_id: Int64?
    /// External user ID. Injected by the SDK from the active session; consumers omit it.
    public var ext_user_id: String?
    /// Platform external user ID. Injected by the SDK from the active session; consumers omit it.
    public var smartico_ext_user_id: String?
    /// Language code for translations (e.g. 'EN', 'DE'). Defaults to the session language.
    public var lang: String?
    /// ID of the specific round
    public var round_id: Int64?

    public init(
        saw_template_id: Int64? = nil,
        ext_user_id: String? = nil,
        smartico_ext_user_id: String? = nil,
        lang: String? = nil,
        round_id: Int64? = nil
    ) {
        self.saw_template_id = saw_template_id
        self.ext_user_id = ext_user_id
        self.smartico_ext_user_id = smartico_ext_user_id
        self.lang = lang
        self.round_id = round_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.saw_template_id = try c.lenientInt64("saw_template_id")
        self.ext_user_id = try c.lenientString("ext_user_id")
        self.smartico_ext_user_id = try c.lenientString("smartico_ext_user_id")
        self.lang = try c.lenientString("lang")
        self.round_id = try c.lenientInt64("round_id")
    }
}
// Inherited fields from GamePickRequestParams are flattened above.
