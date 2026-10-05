// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// One per-game / per-provider override of a jackpot's default contribution.
///
/// When a qualifying bet matches a rule's `extEntityIds`, that rule's
/// `contributionValue` and `type` are used instead of the template-level
/// `contribution_value` / `contribution_type`. Rules are informational for
/// consumers — the server applies them. Note the camelCase field names; the rest
/// of the jackpot payload is snake_case.
public struct JackpotContributionRule: Codable, Hashable, Sendable {
    /// Stable ID of the rule within its template
    public var ruleId: Double?
    /// Template this rule belongs to
    public var jpTemplateId: Double?
    /// Whether `contributionValue` is a fixed amount or a percentage; see {@link JackpotContributionType}
    public var type: Int64?
    /// Operator-side game or provider IDs this rule applies to
    public var extEntityIds: [String]?
    /// Contribution to apply for matching bets — fixed amount or percentage depending on `type`
    public var contributionValue: Double?

    public init(
        ruleId: Double? = nil,
        jpTemplateId: Double? = nil,
        type: Int64? = nil,
        extEntityIds: [String]? = nil,
        contributionValue: Double? = nil
    ) {
        self.ruleId = ruleId
        self.jpTemplateId = jpTemplateId
        self.type = type
        self.extEntityIds = extEntityIds
        self.contributionValue = contributionValue
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ruleId = try c.lenientDouble("ruleId")
        self.jpTemplateId = try c.lenientDouble("jpTemplateId")
        self.type = try c.lenientInt64("type")
        self.extEntityIds = try c.lenientList(String.self, "extEntityIds")
        self.contributionValue = try c.lenientDouble("contributionValue")
    }
}
