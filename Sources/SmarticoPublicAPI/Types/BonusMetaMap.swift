// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct BonusMetaMap: Codable, Hashable, Sendable {
    public var uiAmount: String?

    public init(
        uiAmount: String? = nil
    ) {
        self.uiAmount = uiAmount
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.uiAmount = try c.lenientString("uiAmount")
    }
}
