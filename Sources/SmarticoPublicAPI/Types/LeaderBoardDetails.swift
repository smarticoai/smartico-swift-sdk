// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct LeaderBoardDetails: Codable, Hashable, Sendable {
    public var board_id: Int64?
    public var period_type_id: Int64?
    public var create_date: Int64?
    public var versiod_id: Int64?
    public var reward_points: [Int64]?
    public var board_public_meta: LeaderBoardPublicMeta?
    public var positions: [LeaderBoardPosition]?
    public var userPosition: LeaderBoardPosition?

    public init(
        board_id: Int64? = nil,
        period_type_id: Int64? = nil,
        create_date: Int64? = nil,
        versiod_id: Int64? = nil,
        reward_points: [Int64]? = nil,
        board_public_meta: LeaderBoardPublicMeta? = nil,
        positions: [LeaderBoardPosition]? = nil,
        userPosition: LeaderBoardPosition? = nil
    ) {
        self.board_id = board_id
        self.period_type_id = period_type_id
        self.create_date = create_date
        self.versiod_id = versiod_id
        self.reward_points = reward_points
        self.board_public_meta = board_public_meta
        self.positions = positions
        self.userPosition = userPosition
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.board_id = try c.lenientInt64("board_id")
        self.period_type_id = try c.lenientInt64("period_type_id")
        self.create_date = try c.lenientInt64("create_date")
        self.versiod_id = try c.lenientInt64("versiod_id")
        self.reward_points = try c.lenientList(Int64.self, "reward_points")
        self.board_public_meta = try c.lenientObject(LeaderBoardPublicMeta.self, "board_public_meta")
        self.positions = try c.lenientList(LeaderBoardPosition.self, "positions")
        self.userPosition = try c.lenientObject(LeaderBoardPosition.self, "userPosition")
    }
}
