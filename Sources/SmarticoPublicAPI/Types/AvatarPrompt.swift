// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AvatarPrompt: Codable, Hashable, Sendable {
    /// Unique identifier of the AI customization prompt
    public var prompt_id: Int64?
    /// Public metadata for the prompt
    public var public_meta: JSON?
    /// Currency type used to pay for this customization (0=points, 1=gems, 2=diamonds)
    public var cost_currency_type_id: Int64?
    /// Cost amount in the given currency
    public var cost_value: Double?

    public init(
        prompt_id: Int64? = nil,
        public_meta: JSON? = nil,
        cost_currency_type_id: Int64? = nil,
        cost_value: Double? = nil
    ) {
        self.prompt_id = prompt_id
        self.public_meta = public_meta
        self.cost_currency_type_id = cost_currency_type_id
        self.cost_value = cost_value
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.prompt_id = try c.lenientInt64("prompt_id")
        self.public_meta = try c.lenientJSON("public_meta")
        self.cost_currency_type_id = try c.lenientInt64("cost_currency_type_id")
        self.cost_value = try c.lenientDouble("cost_value")
    }
}
