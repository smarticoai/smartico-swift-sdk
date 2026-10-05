// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// UserLevelExtraCountersT exposes the user's current values for the two
/// label-defined sliding-window level counters. Returned by
/// `Smartico.api.getUserLevelExtraCounters()`. Both fields are
/// `undefined` on points-only labels.
public struct UserLevelExtraCountersT: Codable, Hashable, Sendable {
    /// Current value of the user's first level counter. Operator-defined
    /// semantics per label. `undefined` on points-only labels.
    public var level_counter_1: Int64?
    /// Current value of the user's second level counter. Operator-defined
    /// semantics per label. `undefined` on points-only labels.
    public var level_counter_2: Int64?

    public init(
        level_counter_1: Int64? = nil,
        level_counter_2: Int64? = nil
    ) {
        self.level_counter_1 = level_counter_1
        self.level_counter_2 = level_counter_2
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.level_counter_1 = try c.lenientInt64("level_counter_1")
        self.level_counter_2 = try c.lenientInt64("level_counter_2")
    }
}
