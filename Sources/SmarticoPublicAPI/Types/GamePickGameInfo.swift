// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickGameInfo describes the game configuration including SAW template, rounds list, and label settings
public struct GamePickGameInfo: Codable, Hashable, Sendable {
    /// Game template configuration (SAW template) with UI settings, buy-in type, cost, and spin count
    public var sawTemplate: SAWTemplate?
    /// List of all rounds (metadata only, no events)
    public var allRounds: [GamePickRoundBase]?
    /// Label/brand configuration and settings
    public var labelInfo: JSON?

    public init(
        sawTemplate: SAWTemplate? = nil,
        allRounds: [GamePickRoundBase]? = nil,
        labelInfo: JSON? = nil
    ) {
        self.sawTemplate = sawTemplate
        self.allRounds = allRounds
        self.labelInfo = labelInfo
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.sawTemplate = try c.lenientObject(SAWTemplate.self, "sawTemplate")
        self.allRounds = try c.lenientList(GamePickRoundBase.self, "allRounds")
        self.labelInfo = try c.lenientJSON("labelInfo")
    }
}
