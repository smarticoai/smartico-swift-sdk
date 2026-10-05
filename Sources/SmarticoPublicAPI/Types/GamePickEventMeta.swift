// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickEventMeta describes metadata for a MatchX or Quiz event, including team info and sport context
public struct GamePickEventMeta: Codable, Hashable, Sendable {
    /// List of possible answer options for the quiz question
    public var answers: JSON?
    /// URL of an image associated with the question
    public var question_image: String?
    /// Correct answer value after resolution
    public var result: String?
    /// Custom question text displayed to the user
    public var custom_question: String?
    /// Display name of the event/match
    public var event_name: String?
    /// Name of the first team (home)
    public var team1_name: String?
    /// URL of the first team's logo image
    public var team1_image: String?
    /// Name of the second team (away)
    public var team2_name: String?
    /// URL of the second team's logo image
    public var team2_image: String?
    /// Actual result score for team 1 after resolution
    public var team1_result: Double?
    /// Actual result score for team 2 after resolution
    public var team2_result: Double?
    /// Betradar sport type ID for the event
    public var sport_type_id: Int64?
    /// Whether the event has been canceled
    public var is_canceled: Bool?
    /// Whether auto-resolution from live data feed is enabled
    public var auto_resolve_enabled: Bool?
    /// ISO date string for when auto-resolution is expected
    public var auto_resolve_date: String?
    /// Auto-resolved score for team 1 from live data feed
    public var team1_auto_result: Double?
    /// Auto-resolved score for team 2 from live data feed
    public var team2_auto_result: Double?
    /// Auto-resolved answer value from live data feed (for quiz events)
    public var auto_result: String?
    /// Per-language overrides for team names, event name, and custom question
    public var _translations: JSON?

    public init(
        answers: JSON? = nil,
        question_image: String? = nil,
        result: String? = nil,
        custom_question: String? = nil,
        event_name: String? = nil,
        team1_name: String? = nil,
        team1_image: String? = nil,
        team2_name: String? = nil,
        team2_image: String? = nil,
        team1_result: Double? = nil,
        team2_result: Double? = nil,
        sport_type_id: Int64? = nil,
        is_canceled: Bool? = nil,
        auto_resolve_enabled: Bool? = nil,
        auto_resolve_date: String? = nil,
        team1_auto_result: Double? = nil,
        team2_auto_result: Double? = nil,
        auto_result: String? = nil,
        _translations: JSON? = nil
    ) {
        self.answers = answers
        self.question_image = question_image
        self.result = result
        self.custom_question = custom_question
        self.event_name = event_name
        self.team1_name = team1_name
        self.team1_image = team1_image
        self.team2_name = team2_name
        self.team2_image = team2_image
        self.team1_result = team1_result
        self.team2_result = team2_result
        self.sport_type_id = sport_type_id
        self.is_canceled = is_canceled
        self.auto_resolve_enabled = auto_resolve_enabled
        self.auto_resolve_date = auto_resolve_date
        self.team1_auto_result = team1_auto_result
        self.team2_auto_result = team2_auto_result
        self.auto_result = auto_result
        self._translations = _translations
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.answers = try c.lenientJSON("answers")
        self.question_image = try c.lenientString("question_image")
        self.result = try c.lenientString("result")
        self.custom_question = try c.lenientString("custom_question")
        self.event_name = try c.lenientString("event_name")
        self.team1_name = try c.lenientString("team1_name")
        self.team1_image = try c.lenientString("team1_image")
        self.team2_name = try c.lenientString("team2_name")
        self.team2_image = try c.lenientString("team2_image")
        self.team1_result = try c.lenientDouble("team1_result")
        self.team2_result = try c.lenientDouble("team2_result")
        self.sport_type_id = try c.lenientInt64("sport_type_id")
        self.is_canceled = try c.lenientBool("is_canceled")
        self.auto_resolve_enabled = try c.lenientBool("auto_resolve_enabled")
        self.auto_resolve_date = try c.lenientString("auto_resolve_date")
        self.team1_auto_result = try c.lenientDouble("team1_auto_result")
        self.team2_auto_result = try c.lenientDouble("team2_auto_result")
        self.auto_result = try c.lenientString("auto_result")
        self._translations = try c.lenientJSON("_translations")
    }
}
// Inherited fields from QuizEventMeta are flattened above.
