// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickEvent describes a single event (match or question) within a round, including the user's prediction and resolution
public struct GamePickEvent: Codable, Hashable, Sendable {
    /// Unique identifier of the event
    public var gp_event_id: Int64?
    /// ISO 8601 date-time string when the event was resolved; null until resolved.
    public var event_resolution_date: String?
    /// ISO 8601 date-time string of the match/event start time.
    public var match_date: String?
    /// Market type defining the prediction format (e.g. two-team score, quiz question, custom)
    public var market_type_id: Int64?
    /// Event metadata containing team names, images, sport type, and question details
    public var event_meta: GamePickEventMeta?
    /// Whether the current user has submitted a prediction for this event
    public var user_placed_bet: Bool?
    /// User's predicted score for team 1 (MatchX only). Can be a number or a range object
    public var team1_user_selection: JSON?
    /// User's predicted score for team 2 (MatchX only). Can be a number or a range object
    public var team2_user_selection: JSON?
    /// User's selected answer (Quiz only). Value depends on market type (e.g. '1', '2', 'x', 'yes', 'no')
    public var user_selection: String?
    /// How the user's prediction was scored after resolution
    public var resolution_type_id: Int64?
    /// Points awarded for this event based on prediction accuracy
    public var resolution_score: Double?
    /// Whether this event is still accepting predictions
    public var is_open_for_bets: Bool?
    /// Per-outcome numbers keyed by the outcome value (`'1'` / `'x'` / `'2'`, `'yes'` / `'no'`, …).
    /// Dual-purpose by event type:
    /// - Sports / MatchX: decimal **betting odds** (e.g. `{ "1": 2.45, "x": 3.26, "2": 3.01 }`).
    /// - Quiz: when the round's `show_users_preference` is `true`, these are aggregated
    ///   **user-preference percentages** — what other users predicted, summing to ~100
    ///   (e.g. `{ "1": 33, "x": 25, "2": 42 }`). Render as the "what others predicted" bar.
    public var odds_details: JSON?
    /// URL of a question-specific image (quiz events)
    public var question_image: String?

    public init(
        gp_event_id: Int64? = nil,
        event_resolution_date: String? = nil,
        match_date: String? = nil,
        market_type_id: Int64? = nil,
        event_meta: GamePickEventMeta? = nil,
        user_placed_bet: Bool? = nil,
        team1_user_selection: JSON? = nil,
        team2_user_selection: JSON? = nil,
        user_selection: String? = nil,
        resolution_type_id: Int64? = nil,
        resolution_score: Double? = nil,
        is_open_for_bets: Bool? = nil,
        odds_details: JSON? = nil,
        question_image: String? = nil
    ) {
        self.gp_event_id = gp_event_id
        self.event_resolution_date = event_resolution_date
        self.match_date = match_date
        self.market_type_id = market_type_id
        self.event_meta = event_meta
        self.user_placed_bet = user_placed_bet
        self.team1_user_selection = team1_user_selection
        self.team2_user_selection = team2_user_selection
        self.user_selection = user_selection
        self.resolution_type_id = resolution_type_id
        self.resolution_score = resolution_score
        self.is_open_for_bets = is_open_for_bets
        self.odds_details = odds_details
        self.question_image = question_image
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.gp_event_id = try c.lenientInt64("gp_event_id")
        self.event_resolution_date = try c.lenientString("event_resolution_date")
        self.match_date = try c.lenientString("match_date")
        self.market_type_id = try c.lenientInt64("market_type_id")
        self.event_meta = try c.lenientObject(GamePickEventMeta.self, "event_meta")
        self.user_placed_bet = try c.lenientBool("user_placed_bet")
        self.team1_user_selection = try c.lenientJSON("team1_user_selection")
        self.team2_user_selection = try c.lenientJSON("team2_user_selection")
        self.user_selection = try c.lenientString("user_selection")
        self.resolution_type_id = try c.lenientInt64("resolution_type_id")
        self.resolution_score = try c.lenientDouble("resolution_score")
        self.is_open_for_bets = try c.lenientBool("is_open_for_bets")
        self.odds_details = try c.lenientJSON("odds_details")
        self.question_image = try c.lenientString("question_image")
    }
}
