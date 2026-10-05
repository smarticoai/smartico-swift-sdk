// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One AI style prompt for avatar customization. Returned by `getAvatarPrompts()`.
/// Fields from the raw `public_meta` object are flattened to the top level.
public struct TAvatarPrompt: Codable, Hashable, Sendable {
    /// Stable numeric identifier of the prompt.
    public var prompt_id: Int64?
    /// Display name of the style, e.g. "Cartoon", "Watercolor".
    public var name: String?
    /// Absolute CDN URL of the prompt's preview icon.
    public var icon_url: String?
    /// Currency used to pay for the customization. `0` = points, `1` = gems, `2` = diamonds, `3` = free. A `cost_value` of `0` is also free.
    public var cost_currency_type_id: Int64?
    /// Cost amount in the currency named by `cost_currency_type_id`. `0` = free.
    public var cost_value: Double?

    public init(
        prompt_id: Int64? = nil,
        name: String? = nil,
        icon_url: String? = nil,
        cost_currency_type_id: Int64? = nil,
        cost_value: Double? = nil
    ) {
        self.prompt_id = prompt_id
        self.name = name
        self.icon_url = icon_url
        self.cost_currency_type_id = cost_currency_type_id
        self.cost_value = cost_value
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.prompt_id = try c.lenientInt64("prompt_id")
        self.name = try c.lenientString("name")
        self.icon_url = try c.lenientString("icon_url")
        self.cost_currency_type_id = try c.lenientInt64("cost_currency_type_id")
        self.cost_value = try c.lenientDouble("cost_value")
    }
}
