// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct AchRelatedGame: Codable, Hashable, Sendable {
    /// ID of the game on Smartico side
    public var ach_game_id: Int64?
    /// ID of the game on operator side
    public var ext_game_id: String?
    public var game_public_meta: JSON?

    public init(
        ach_game_id: Int64? = nil,
        ext_game_id: String? = nil,
        game_public_meta: JSON? = nil
    ) {
        self.ach_game_id = ach_game_id
        self.ext_game_id = ext_game_id
        self.game_public_meta = game_public_meta
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.ach_game_id = try c.lenientInt64("ach_game_id")
        self.ext_game_id = try c.lenientString("ext_game_id")
        self.game_public_meta = try c.lenientJSON("game_public_meta")
    }
}
