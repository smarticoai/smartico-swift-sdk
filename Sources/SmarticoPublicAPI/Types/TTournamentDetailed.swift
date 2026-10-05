// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TTournamentDetailed describes the information of the tournament item and includes list of participants, their scores and position in the tournament leaderboard
public struct TTournamentDetailed: Codable, Hashable, Sendable {
    /// ID of tournament instance. Generated every time when tournament based on specific template is scheduled for run
    public var instance_id: Int64?
    /// ID of tournament template
    public var tournament_id: Int64?
    /// Name of the tournament, translated to the user language
    public var name: String?
    /// Description of the tournament, translated to the user language
    public var description: String?
    /// 1st image URL representing the tournament, 544×216px
    public var image1: String?
    /// 2nd image URL representing the tournament, 920x200px
    public var image2: String?
    /// 2nd image URL representing the tournament for mobile, 720x400px
    public var image2_mobile: String?
    /// The message indicating the prize pool of the tournament
    public var prize_pool_short: String?
    /// The message indicating the price to register in the tournament
    public var custom_price_text: String?
    /// The message that should be shown to the user when the user cannot register in tournament with error code TOURNAMENT_USER_DONT_MATCH_CONDITIONS
    public var segment_dont_match_message: String?
    /// The ID of the custom section where the tournament is assigned
    /// The list of custom sections can be retrieved using Smartico.api.getCustomSections() method
    public var custom_section_id: Int64?
    /// The indicator if the tournament is visible only in the custom section and should be hidden from the main overview of tournaments
    public var only_in_custom_section: Bool?
    /// The custom data of the tournament defined by operator. Can be a JSON object, string or number
    public var custom_data: JSON?
    /// The indicator if the tournament is 'Featured'
    public var is_featured: Bool?
    /// The ribbon of the tournament item. Can be 'sale', 'hot', 'new', 'vip' or URL to the image in case of custom ribbon, 250×300px
    public var ribbon: JSON?
    /// A number is used to order the tournaments, representing their priority in the list
    public var priority: Int64?
    /// The time when tournament is going to start, epoch with milliseconds
    public var start_time: Int64?
    /// The time when tournament is going to finish, epoch with milliseconds
    public var end_time: Int64?
    /// Type of registration in the tournament
    public var registration_type: TournamentRegistrationTypeName?
    /// Number of users registered in the tournament
    public var registration_count: Int64?
    /// flag indicating if current user is registered in the tournament
    public var is_user_registered: Bool?
    /// Minimum number of participant for this tournament. If tournament doesnt have enough registrations, it will not start
    public var players_min_count: Int64?
    /// Maximum number of participant for this tournament. When reached, new users won't be able to register
    public var players_max_count: Int64?
    /// Status of registration in the tournament for current user
    public var registration_status: String?
    /// Tournament duration in millisecnnds
    public var duration_ms: Int64?
    /// Cost of registration in the tournament in gamification points
    public var registration_cost_points: Int64?
    /// Cost of registration in the tournament in gems
    public var registration_cost_gems: Double?
    /// Cost of registration in the tournament in diamonds
    public var registration_cost_diamonds: Double?
    /// Indicator if tournament instance is active, means in one of the statues -  PUBLISHED, REGISTED, STARTED
    public var is_active: Bool?
    /// Indicator if user can register in this tournament instance, e.g tournament is active, max users is not reached, user is not registered yet
    public var is_can_register: Bool?
    /// Indicator if tournament instance is cancelled (status CANCELLED)
    public var is_cancelled: Bool?
    /// Indicator if tournament instance is finished (status FINISHED, CANCELLED OR FINIALIZING)
    public var is_finished: Bool?
    /// Indicator if tournament instance is running (status STARTED)
    public var is_in_progress: Bool?
    /// Indicator if tournament instance is upcoming (status PUBLISHED or REGISTER)
    public var is_upcoming: Bool?
    /// The minimum amount of score points that the user should get in order to be qualified for the prize
    public var min_scores_win: Double?
    /// When enabled, users who don’t meet the minimum qualifying score will be hidden from the Leaderboard
    public var hide_leaderboard_min_scores: Bool?
    /// Total scores across all participants in the tournament
    public var total_scores: Double?
    /// True when this tournament groups participants by clan
    public var is_clan_based: Bool?
    /// List of casino games (or other types of entities) related to the tournament
    public var related_games: [AchRelatedGame]?
    /// The list of the tournament participants
    public var players: [TTournamentPlayer]?
    /// The information about current user in the tournament if he is registered in the tournamnet
    public var me: TTournamentMe?
    public var prizes: [TTournamentPrize]?
    /// Ranked list of clans in this tournament; null for non-clan tournaments
    public var clan_leaderboard: [TTournamentClanRank]?
    /// The clan ID the current user belongs to; null when clanless or non-clan tournament
    public var user_clan_id: Int64?
    /// The user's rank within their own clan; null when clanless or not registered
    public var user_position_in_clan: Int64?
    /// The user's score contribution to their clan; null when clanless or not registered
    public var user_score_in_clan: Double?
    /// Per-clan prize structure; null for non-clan tournaments
    public var clan_prize_structure: JSON?

    public init(
        instance_id: Int64? = nil,
        tournament_id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        image1: String? = nil,
        image2: String? = nil,
        image2_mobile: String? = nil,
        prize_pool_short: String? = nil,
        custom_price_text: String? = nil,
        segment_dont_match_message: String? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        custom_data: JSON? = nil,
        is_featured: Bool? = nil,
        ribbon: JSON? = nil,
        priority: Int64? = nil,
        start_time: Int64? = nil,
        end_time: Int64? = nil,
        registration_type: TournamentRegistrationTypeName? = nil,
        registration_count: Int64? = nil,
        is_user_registered: Bool? = nil,
        players_min_count: Int64? = nil,
        players_max_count: Int64? = nil,
        registration_status: String? = nil,
        duration_ms: Int64? = nil,
        registration_cost_points: Int64? = nil,
        registration_cost_gems: Double? = nil,
        registration_cost_diamonds: Double? = nil,
        is_active: Bool? = nil,
        is_can_register: Bool? = nil,
        is_cancelled: Bool? = nil,
        is_finished: Bool? = nil,
        is_in_progress: Bool? = nil,
        is_upcoming: Bool? = nil,
        min_scores_win: Double? = nil,
        hide_leaderboard_min_scores: Bool? = nil,
        total_scores: Double? = nil,
        is_clan_based: Bool? = nil,
        related_games: [AchRelatedGame]? = nil,
        players: [TTournamentPlayer]? = nil,
        me: TTournamentMe? = nil,
        prizes: [TTournamentPrize]? = nil,
        clan_leaderboard: [TTournamentClanRank]? = nil,
        user_clan_id: Int64? = nil,
        user_position_in_clan: Int64? = nil,
        user_score_in_clan: Double? = nil,
        clan_prize_structure: JSON? = nil
    ) {
        self.instance_id = instance_id
        self.tournament_id = tournament_id
        self.name = name
        self.description = description
        self.image1 = image1
        self.image2 = image2
        self.image2_mobile = image2_mobile
        self.prize_pool_short = prize_pool_short
        self.custom_price_text = custom_price_text
        self.segment_dont_match_message = segment_dont_match_message
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.custom_data = custom_data
        self.is_featured = is_featured
        self.ribbon = ribbon
        self.priority = priority
        self.start_time = start_time
        self.end_time = end_time
        self.registration_type = registration_type
        self.registration_count = registration_count
        self.is_user_registered = is_user_registered
        self.players_min_count = players_min_count
        self.players_max_count = players_max_count
        self.registration_status = registration_status
        self.duration_ms = duration_ms
        self.registration_cost_points = registration_cost_points
        self.registration_cost_gems = registration_cost_gems
        self.registration_cost_diamonds = registration_cost_diamonds
        self.is_active = is_active
        self.is_can_register = is_can_register
        self.is_cancelled = is_cancelled
        self.is_finished = is_finished
        self.is_in_progress = is_in_progress
        self.is_upcoming = is_upcoming
        self.min_scores_win = min_scores_win
        self.hide_leaderboard_min_scores = hide_leaderboard_min_scores
        self.total_scores = total_scores
        self.is_clan_based = is_clan_based
        self.related_games = related_games
        self.players = players
        self.me = me
        self.prizes = prizes
        self.clan_leaderboard = clan_leaderboard
        self.user_clan_id = user_clan_id
        self.user_position_in_clan = user_position_in_clan
        self.user_score_in_clan = user_score_in_clan
        self.clan_prize_structure = clan_prize_structure
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.instance_id = try c.lenientInt64("instance_id")
        self.tournament_id = try c.lenientInt64("tournament_id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image1 = try c.lenientString("image1")
        self.image2 = try c.lenientString("image2")
        self.image2_mobile = try c.lenientString("image2_mobile")
        self.prize_pool_short = try c.lenientString("prize_pool_short")
        self.custom_price_text = try c.lenientString("custom_price_text")
        self.segment_dont_match_message = try c.lenientString("segment_dont_match_message")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.custom_data = try c.lenientJSON("custom_data")
        self.is_featured = try c.lenientBool("is_featured")
        self.ribbon = try c.lenientJSON("ribbon")
        self.priority = try c.lenientInt64("priority")
        self.start_time = try c.lenientInt64("start_time")
        self.end_time = try c.lenientInt64("end_time")
        self.registration_type = try c.lenientString("registration_type")
        self.registration_count = try c.lenientInt64("registration_count")
        self.is_user_registered = try c.lenientBool("is_user_registered")
        self.players_min_count = try c.lenientInt64("players_min_count")
        self.players_max_count = try c.lenientInt64("players_max_count")
        self.registration_status = try c.lenientString("registration_status")
        self.duration_ms = try c.lenientInt64("duration_ms")
        self.registration_cost_points = try c.lenientInt64("registration_cost_points")
        self.registration_cost_gems = try c.lenientDouble("registration_cost_gems")
        self.registration_cost_diamonds = try c.lenientDouble("registration_cost_diamonds")
        self.is_active = try c.lenientBool("is_active")
        self.is_can_register = try c.lenientBool("is_can_register")
        self.is_cancelled = try c.lenientBool("is_cancelled")
        self.is_finished = try c.lenientBool("is_finished")
        self.is_in_progress = try c.lenientBool("is_in_progress")
        self.is_upcoming = try c.lenientBool("is_upcoming")
        self.min_scores_win = try c.lenientDouble("min_scores_win")
        self.hide_leaderboard_min_scores = try c.lenientBool("hide_leaderboard_min_scores")
        self.total_scores = try c.lenientDouble("total_scores")
        self.is_clan_based = try c.lenientBool("is_clan_based")
        self.related_games = try c.lenientList(AchRelatedGame.self, "related_games")
        self.players = try c.lenientList(TTournamentPlayer.self, "players")
        self.me = try c.lenientObject(TTournamentMe.self, "me")
        self.prizes = try c.lenientList(TTournamentPrize.self, "prizes")
        self.clan_leaderboard = try c.lenientList(TTournamentClanRank.self, "clan_leaderboard")
        self.user_clan_id = try c.lenientInt64("user_clan_id")
        self.user_position_in_clan = try c.lenientInt64("user_position_in_clan")
        self.user_score_in_clan = try c.lenientDouble("user_score_in_clan")
        self.clan_prize_structure = try c.lenientJSON("clan_prize_structure")
    }
}
// Inherited fields from TTournament are flattened above.
