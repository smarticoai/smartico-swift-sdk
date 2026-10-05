// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// LeaderBoardDetailsT describes one period's leaderboard.
/// Returned by `Smartico.api.getLeaderBoard(periodType, getPreviousPeriod?)`.
/// May be `undefined` at runtime when no board is configured for the requested period.
public struct LeaderBoardDetailsT: Codable, Hashable, Sendable {
    /// Stable ID of the leaderboard.
    public var board_id: Int64?
    /// Operator-defined display name.
    public var name: String?
    /// Operator-defined description (HTML allowed).
    public var description: String?
    /// Operator-defined rules / terms (HTML allowed).
    public var rules: String?
    /// Period type this board is bound to ({@link LeaderBoardPeriodType}).
    public var period_type_id: Int64?
    /// Snapshot version. `0` for the live current period; a positive value
    /// identifies a finalized previous-period snapshot (see `getPreviousPeriod`).
    public var version_id: Int64?
    /// Snapshot creation timestamp (Unix ms). `0` for the live current period;
    /// the finalization time for a previous-period snapshot.
    public var create_date: Int64?
    /// Per-place prize table; the array length is the number of paid places.
    public var rewards: [LeaderBoardsRewardsT]?
    /// Top-20 ranked entries (server-capped), sorted by `position` ASC.
    /// Empty when fetched via `getLeaderBoards()` (metadata-only list).
    public var users: [LeaderBoardUserT]?
    /// Current user's own entry. `undefined` for visitor sessions.
    /// For authenticated users, `position === -1` means the user is
    /// unranked / outside the ranked window.
    public var me: LeaderBoardUserT?

    public init(
        board_id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        rules: String? = nil,
        period_type_id: Int64? = nil,
        version_id: Int64? = nil,
        create_date: Int64? = nil,
        rewards: [LeaderBoardsRewardsT]? = nil,
        users: [LeaderBoardUserT]? = nil,
        me: LeaderBoardUserT? = nil
    ) {
        self.board_id = board_id
        self.name = name
        self.description = description
        self.rules = rules
        self.period_type_id = period_type_id
        self.version_id = version_id
        self.create_date = create_date
        self.rewards = rewards
        self.users = users
        self.me = me
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.board_id = try c.lenientInt64("board_id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.rules = try c.lenientString("rules")
        self.period_type_id = try c.lenientInt64("period_type_id")
        self.version_id = try c.lenientInt64("version_id")
        self.create_date = try c.lenientInt64("create_date")
        self.rewards = try c.lenientList(LeaderBoardsRewardsT.self, "rewards")
        self.users = try c.lenientList(LeaderBoardUserT.self, "users")
        self.me = try c.lenientObject(LeaderBoardUserT.self, "me")
    }
}
