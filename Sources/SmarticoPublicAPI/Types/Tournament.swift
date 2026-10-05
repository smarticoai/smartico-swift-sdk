// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct Tournament: Codable, Hashable, Sendable {
    /// ID of tournament template
    public var tournamentId: Double?
    /// ID of tournament instance. Generated every time when tournament based on specific template is scheduled for run
    public var tournamentInstanceId: Double?
    /// Type of the tournament. For now only SCHEDULED is support
    public var tournamentType: Int64?
    /// Meta information about tournament that should be used to build UI
    public var publicMeta: TournamentPublicMeta?
    /// Cost of registration in the tournament in gamification points
    public var buyInAmount: Double?
    /// Not in use
    public var prizePool: Double?
    /// The time when tournament is going to start
    public var startTime: String?
    /// The time when tournament is going to finish
    public var endTime: String?
    /// The time when tournament is going to start, epoch
    public var startTimeTs: Double?
    /// The time when tournament is going to finish, epoch
    public var endTimeTs: Double?
    /// Number of users registered in the tournament
    public var registrationCount: Int64?
    /// Not in use
    public var totalCount: Int64?
    /// Type of registration in the tournament
    public var registrationType: Int64?
    /// Status of registration in the tournament for current user
    public var tournamentRegistrationStatus: Int64?
    /// Status of tournament instance
    public var tournamentInstanceStatus: Int64?
    /// flag indicating if current user is registered in the tournament
    public var isUserRegistered: Bool?
    /// Indicator if tournament allows later registration, when tournament is already started
    public var allowLateRegistration: Bool?
    /// Minimum number of participant for this tournament. If tournament doesnt have enough registrations, it will not start
    public var playersMinCount: Int64?
    /// Maximum number of participant for this tournament. When reached, new users won't be able to register
    public var playersMaxCount: Int64?
    /// Tournament duration in millisecnnds
    public var durationMs: Int64?
    /// prizes structure
    public var prizeStructure: JSON?
    /// Information about current user
    public var tournamentPlayer: TournamentPlayer?
    /// List of casino games (or other types of entities) related to the tournament
    public var related_games: [AchRelatedGame]?
    /// The minimum amount of score points that the user should get in order to be qualified for the prize
    public var minScoreToWin: Double?
    /// When enabled, users who don't meet the minimum qualifying score will be hidden from the Leaderboard.
    public var hideLeaderboardsMinScores: Bool?
    /// Total scores across all participants in the tournament
    public var totalScores: Double?
    /// Indicates if the tournament is clan-based
    public var isClanBased: Bool?

    public init(
        tournamentId: Double? = nil,
        tournamentInstanceId: Double? = nil,
        tournamentType: Int64? = nil,
        publicMeta: TournamentPublicMeta? = nil,
        buyInAmount: Double? = nil,
        prizePool: Double? = nil,
        startTime: String? = nil,
        endTime: String? = nil,
        startTimeTs: Double? = nil,
        endTimeTs: Double? = nil,
        registrationCount: Int64? = nil,
        totalCount: Int64? = nil,
        registrationType: Int64? = nil,
        tournamentRegistrationStatus: Int64? = nil,
        tournamentInstanceStatus: Int64? = nil,
        isUserRegistered: Bool? = nil,
        allowLateRegistration: Bool? = nil,
        playersMinCount: Int64? = nil,
        playersMaxCount: Int64? = nil,
        durationMs: Int64? = nil,
        prizeStructure: JSON? = nil,
        tournamentPlayer: TournamentPlayer? = nil,
        related_games: [AchRelatedGame]? = nil,
        minScoreToWin: Double? = nil,
        hideLeaderboardsMinScores: Bool? = nil,
        totalScores: Double? = nil,
        isClanBased: Bool? = nil
    ) {
        self.tournamentId = tournamentId
        self.tournamentInstanceId = tournamentInstanceId
        self.tournamentType = tournamentType
        self.publicMeta = publicMeta
        self.buyInAmount = buyInAmount
        self.prizePool = prizePool
        self.startTime = startTime
        self.endTime = endTime
        self.startTimeTs = startTimeTs
        self.endTimeTs = endTimeTs
        self.registrationCount = registrationCount
        self.totalCount = totalCount
        self.registrationType = registrationType
        self.tournamentRegistrationStatus = tournamentRegistrationStatus
        self.tournamentInstanceStatus = tournamentInstanceStatus
        self.isUserRegistered = isUserRegistered
        self.allowLateRegistration = allowLateRegistration
        self.playersMinCount = playersMinCount
        self.playersMaxCount = playersMaxCount
        self.durationMs = durationMs
        self.prizeStructure = prizeStructure
        self.tournamentPlayer = tournamentPlayer
        self.related_games = related_games
        self.minScoreToWin = minScoreToWin
        self.hideLeaderboardsMinScores = hideLeaderboardsMinScores
        self.totalScores = totalScores
        self.isClanBased = isClanBased
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.tournamentId = try c.lenientDouble("tournamentId")
        self.tournamentInstanceId = try c.lenientDouble("tournamentInstanceId")
        self.tournamentType = try c.lenientInt64("tournamentType")
        self.publicMeta = try c.lenientObject(TournamentPublicMeta.self, "publicMeta")
        self.buyInAmount = try c.lenientDouble("buyInAmount")
        self.prizePool = try c.lenientDouble("prizePool")
        self.startTime = try c.lenientString("startTime")
        self.endTime = try c.lenientString("endTime")
        self.startTimeTs = try c.lenientDouble("startTimeTs")
        self.endTimeTs = try c.lenientDouble("endTimeTs")
        self.registrationCount = try c.lenientInt64("registrationCount")
        self.totalCount = try c.lenientInt64("totalCount")
        self.registrationType = try c.lenientInt64("registrationType")
        self.tournamentRegistrationStatus = try c.lenientInt64("tournamentRegistrationStatus")
        self.tournamentInstanceStatus = try c.lenientInt64("tournamentInstanceStatus")
        self.isUserRegistered = try c.lenientBool("isUserRegistered")
        self.allowLateRegistration = try c.lenientBool("allowLateRegistration")
        self.playersMinCount = try c.lenientInt64("playersMinCount")
        self.playersMaxCount = try c.lenientInt64("playersMaxCount")
        self.durationMs = try c.lenientInt64("durationMs")
        self.prizeStructure = try c.lenientJSON("prizeStructure")
        self.tournamentPlayer = try c.lenientObject(TournamentPlayer.self, "tournamentPlayer")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.minScoreToWin = try c.lenientDouble("minScoreToWin")
        self.hideLeaderboardsMinScores = try c.lenientBool("hideLeaderboardsMinScores")
        self.totalScores = try c.lenientDouble("totalScores")
        self.isClanBased = try c.lenientBool("isClanBased")
    }
}
