// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// QuizEventMeta describes metadata for a quiz-type event (custom question with answer options)
public struct QuizEventMeta: Codable, Hashable, Sendable {
    /// List of possible answer options for the quiz question
    public var answers: JSON?
    /// URL of an image associated with the question
    public var question_image: String?
    /// Correct answer value after resolution
    public var result: String?
    /// Custom question text displayed to the user
    public var custom_question: String?

    public init(
        answers: JSON? = nil,
        question_image: String? = nil,
        result: String? = nil,
        custom_question: String? = nil
    ) {
        self.answers = answers
        self.question_image = question_image
        self.result = result
        self.custom_question = custom_question
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.answers = try c.lenientJSON("answers")
        self.question_image = try c.lenientString("question_image")
        self.result = try c.lenientString("result")
        self.custom_question = try c.lenientString("custom_question")
    }
}
