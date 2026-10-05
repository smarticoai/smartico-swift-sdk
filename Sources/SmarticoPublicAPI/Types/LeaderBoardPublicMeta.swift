// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct LeaderBoardPublicMeta: Codable, Hashable, Sendable {
    public var name: String?
    public var description: String?
    public var rules: String?

    public init(
        name: String? = nil,
        description: String? = nil,
        rules: String? = nil
    ) {
        self.name = name
        self.description = description
        self.rules = rules
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.rules = try c.lenientString("rules")
    }
}
