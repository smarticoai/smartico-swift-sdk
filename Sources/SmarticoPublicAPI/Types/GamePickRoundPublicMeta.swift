// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GamePickRoundPublicMeta describes the public-facing metadata and translations for a round, configured in the BackOffice
public struct GamePickRoundPublicMeta: Codable, Hashable, Sendable {
    /// Localized round name
    public var round_name: String?
    /// Localized round description
    public var round_description: String?
    /// URL of the promotional image for the round
    public var promo_image: String?
    /// Promotional text displayed with the round
    public var promo_text: String?
    /// Whether to hide the round from the UI after it has been resolved
    public var hide_resolved_round: Bool?
    /// URL of the final screen image for desktop
    public var final_screen_image_desktop: String?
    /// URL of the final screen image for mobile
    public var final_screen_image_mobile: String?
    /// Message displayed on the final/results screen
    public var final_screen_message: String?
    /// Label for the CTA button on the final screen
    public var final_screen_cta_button_title: String?
    /// Deep link triggered by the CTA button on the final screen
    public var final_screen_cta_dp: String?
    /// Whether users can edit their answers after initial submission (within betting window)
    public var allow_edit_answers: Bool?
    /// Per-language overrides for round display content
    public var _translations: JSON?

    public init(
        round_name: String? = nil,
        round_description: String? = nil,
        promo_image: String? = nil,
        promo_text: String? = nil,
        hide_resolved_round: Bool? = nil,
        final_screen_image_desktop: String? = nil,
        final_screen_image_mobile: String? = nil,
        final_screen_message: String? = nil,
        final_screen_cta_button_title: String? = nil,
        final_screen_cta_dp: String? = nil,
        allow_edit_answers: Bool? = nil,
        _translations: JSON? = nil
    ) {
        self.round_name = round_name
        self.round_description = round_description
        self.promo_image = promo_image
        self.promo_text = promo_text
        self.hide_resolved_round = hide_resolved_round
        self.final_screen_image_desktop = final_screen_image_desktop
        self.final_screen_image_mobile = final_screen_image_mobile
        self.final_screen_message = final_screen_message
        self.final_screen_cta_button_title = final_screen_cta_button_title
        self.final_screen_cta_dp = final_screen_cta_dp
        self.allow_edit_answers = allow_edit_answers
        self._translations = _translations
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.round_name = try c.lenientString("round_name")
        self.round_description = try c.lenientString("round_description")
        self.promo_image = try c.lenientString("promo_image")
        self.promo_text = try c.lenientString("promo_text")
        self.hide_resolved_round = try c.lenientBool("hide_resolved_round")
        self.final_screen_image_desktop = try c.lenientString("final_screen_image_desktop")
        self.final_screen_image_mobile = try c.lenientString("final_screen_image_mobile")
        self.final_screen_message = try c.lenientString("final_screen_message")
        self.final_screen_cta_button_title = try c.lenientString("final_screen_cta_button_title")
        self.final_screen_cta_dp = try c.lenientString("final_screen_cta_dp")
        self.allow_edit_answers = try c.lenientBool("allow_edit_answers")
        self._translations = try c.lenientJSON("_translations")
    }
}
