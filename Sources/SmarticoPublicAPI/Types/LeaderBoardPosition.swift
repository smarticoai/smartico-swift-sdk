// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct LeaderBoardPosition: Codable, Hashable, Sendable {
    public var public_username: String?
    public var user_alt_name: String?
    public var position_in_board: Int64?
    public var points_accumulated: Int64?
    public var is_me: Bool?
    public var level_id: Int64?
    public var avatar_id: String?
    public var avatar_url: String?

    public init(
        public_username: String? = nil,
        user_alt_name: String? = nil,
        position_in_board: Int64? = nil,
        points_accumulated: Int64? = nil,
        is_me: Bool? = nil,
        level_id: Int64? = nil,
        avatar_id: String? = nil,
        avatar_url: String? = nil
    ) {
        self.public_username = public_username
        self.user_alt_name = user_alt_name
        self.position_in_board = position_in_board
        self.points_accumulated = points_accumulated
        self.is_me = is_me
        self.level_id = level_id
        self.avatar_id = avatar_id
        self.avatar_url = avatar_url
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.public_username = try c.lenientString("public_username")
        self.user_alt_name = try c.lenientString("user_alt_name")
        self.position_in_board = try c.lenientInt64("position_in_board")
        self.points_accumulated = try c.lenientInt64("points_accumulated")
        self.is_me = try c.lenientBool("is_me")
        self.level_id = try c.lenientInt64("level_id")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_url = try c.lenientString("avatar_url")
    }
}
