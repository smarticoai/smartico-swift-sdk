// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickRoundBoard describes a round's leaderboard with ranked users
public struct GamePickRoundBoard: Codable, Hashable, Sendable {
    /// Unique round identifier
    public var round_id: Int64?
    /// Sequential row ID used for ordering rounds
    public var round_row_id: Int64?
    /// Localized display name of the round
    public var round_name: String?
    /// Localized description of the round
    public var round_description: String?
    /// Label for the CTA button on the final/results screen
    public var final_screen_cta_button_title: String?
    /// Message displayed on the final/results screen
    public var final_screen_message: String?
    /// URL of the final screen image (desktop)
    public var final_screen_image_desktop: String?
    /// URL of the final screen image (mobile)
    public var final_screen_image_mobile: String?
    /// URL of the promotional image for the round
    public var promo_image: String?
    /// Promotional text displayed with the round
    public var promo_text: String?
    /// Timestamp (ms) when the round opens for participation
    public var open_date: Int64?
    /// Timestamp (ms) of the last moment bets are accepted
    public var last_bet_date: Int64?
    /// Timestamp (ms) when the round is expected to be resolved
    public var resolution_date: Int64?
    /// Points awarded for a fully correct prediction
    public var score_full_win: Double?
    /// Points awarded for a partially correct prediction
    public var score_part_win: Double?
    /// Points awarded (or deducted) for an incorrect prediction
    public var score_lost: Double?
    /// Whether the round is currently active for participation
    public var is_active_now: Bool?
    /// Whether the round has been fully resolved and scored
    public var is_resolved: Bool?
    /// Current lifecycle status of the round
    public var round_status_id: Int64?
    /// Total number of events in the round
    public var events_total: Double?
    /// Number of events that have been resolved
    public var events_resolved: Double?
    /// Scoring method used for this round
    public var score_type_id: Int64?
    /// How events are ordered for display
    public var order_events: Int64?
    /// Maximum number of users shown on the leaderboard
    public var board_users_count: Int64?
    /// Whether other users' predictions are hidden until resolution
    public var hide_users_predictions: Bool?
    /// Public metadata including translations and display settings from the BackOffice
    public var public_meta: GamePickRoundPublicMeta?
    /// Timestamp (ms) when the next round opens, if available
    public var next_round_open_date: Int64?
    /// Whether to show aggregated user preference percentages for each outcome
    public var show_users_preference: Bool?
    /// Current user's leaderboard entry, or null if user hasn't participated
    public var my_user: GamePickBoardUser?
    /// Ranked list of users on the leaderboard
    public var users: [GamePickBoardUser]?

    public init(
        round_id: Int64? = nil,
        round_row_id: Int64? = nil,
        round_name: String? = nil,
        round_description: String? = nil,
        final_screen_cta_button_title: String? = nil,
        final_screen_message: String? = nil,
        final_screen_image_desktop: String? = nil,
        final_screen_image_mobile: String? = nil,
        promo_image: String? = nil,
        promo_text: String? = nil,
        open_date: Int64? = nil,
        last_bet_date: Int64? = nil,
        resolution_date: Int64? = nil,
        score_full_win: Double? = nil,
        score_part_win: Double? = nil,
        score_lost: Double? = nil,
        is_active_now: Bool? = nil,
        is_resolved: Bool? = nil,
        round_status_id: Int64? = nil,
        events_total: Double? = nil,
        events_resolved: Double? = nil,
        score_type_id: Int64? = nil,
        order_events: Int64? = nil,
        board_users_count: Int64? = nil,
        hide_users_predictions: Bool? = nil,
        public_meta: GamePickRoundPublicMeta? = nil,
        next_round_open_date: Int64? = nil,
        show_users_preference: Bool? = nil,
        my_user: GamePickBoardUser? = nil,
        users: [GamePickBoardUser]? = nil
    ) {
        self.round_id = round_id
        self.round_row_id = round_row_id
        self.round_name = round_name
        self.round_description = round_description
        self.final_screen_cta_button_title = final_screen_cta_button_title
        self.final_screen_message = final_screen_message
        self.final_screen_image_desktop = final_screen_image_desktop
        self.final_screen_image_mobile = final_screen_image_mobile
        self.promo_image = promo_image
        self.promo_text = promo_text
        self.open_date = open_date
        self.last_bet_date = last_bet_date
        self.resolution_date = resolution_date
        self.score_full_win = score_full_win
        self.score_part_win = score_part_win
        self.score_lost = score_lost
        self.is_active_now = is_active_now
        self.is_resolved = is_resolved
        self.round_status_id = round_status_id
        self.events_total = events_total
        self.events_resolved = events_resolved
        self.score_type_id = score_type_id
        self.order_events = order_events
        self.board_users_count = board_users_count
        self.hide_users_predictions = hide_users_predictions
        self.public_meta = public_meta
        self.next_round_open_date = next_round_open_date
        self.show_users_preference = show_users_preference
        self.my_user = my_user
        self.users = users
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.round_id = try c.lenientInt64("round_id")
        self.round_row_id = try c.lenientInt64("round_row_id")
        self.round_name = try c.lenientString("round_name")
        self.round_description = try c.lenientString("round_description")
        self.final_screen_cta_button_title = try c.lenientString("final_screen_cta_button_title")
        self.final_screen_message = try c.lenientString("final_screen_message")
        self.final_screen_image_desktop = try c.lenientString("final_screen_image_desktop")
        self.final_screen_image_mobile = try c.lenientString("final_screen_image_mobile")
        self.promo_image = try c.lenientString("promo_image")
        self.promo_text = try c.lenientString("promo_text")
        self.open_date = try c.lenientInt64("open_date")
        self.last_bet_date = try c.lenientInt64("last_bet_date")
        self.resolution_date = try c.lenientInt64("resolution_date")
        self.score_full_win = try c.lenientDouble("score_full_win")
        self.score_part_win = try c.lenientDouble("score_part_win")
        self.score_lost = try c.lenientDouble("score_lost")
        self.is_active_now = try c.lenientBool("is_active_now")
        self.is_resolved = try c.lenientBool("is_resolved")
        self.round_status_id = try c.lenientInt64("round_status_id")
        self.events_total = try c.lenientDouble("events_total")
        self.events_resolved = try c.lenientDouble("events_resolved")
        self.score_type_id = try c.lenientInt64("score_type_id")
        self.order_events = try c.lenientInt64("order_events")
        self.board_users_count = try c.lenientInt64("board_users_count")
        self.hide_users_predictions = try c.lenientBool("hide_users_predictions")
        self.public_meta = try c.lenientObject(GamePickRoundPublicMeta.self, "public_meta")
        self.next_round_open_date = try c.lenientInt64("next_round_open_date")
        self.show_users_preference = try c.lenientBool("show_users_preference")
        self.my_user = try c.lenientObject(GamePickBoardUser.self, "my_user")
        self.users = try c.lenientList(GamePickBoardUser.self, "users")
    }
}
// Inherited fields from GamePickRoundBase are flattened above.
