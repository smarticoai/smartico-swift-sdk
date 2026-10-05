// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotPublicMeta: Codable, Hashable, Sendable {
    /// name of the jackpot
    public var name: String?
    /// description/rules of the jackpot
    public var description: String?
    /// image url of the jackpot
    public var image_url: String?
    /// HTML template for the winner of the jackpt
    public var winner_template: JackpotHtmlTemplate?
    /// HTML template for the not winner of the jackpot
    public var not_winner_template: JackpotHtmlTemplate?
    /// custom value of placeholder1 defined by operator and can be used in the HTML templates
    public var placeholder1: String?
    /// custom value of placeholder2 defined by operator and can be used in the HTML templates
    public var placeholder2: String?
    /// operator-defined display order, ascending; sent as a string
    public var priority: String?
    /// Custom data that can be used in API to build custom UI.
    /// `jackpotGet()` returns this already parsed — an object when the operator stored JSON,
    /// otherwise the raw string. Elsewhere (e.g. the jackpot-win push) it arrives unparsed.
    /// You can request from Smartico to define fields for your specific case that will be managed from Smartico BackOffice
    /// Read more here - <https://help.smartico.ai/welcome/products/tools-and-guides/custom-fields-attributes>
    public var custom_data: JSON?

    public init(
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        winner_template: JackpotHtmlTemplate? = nil,
        not_winner_template: JackpotHtmlTemplate? = nil,
        placeholder1: String? = nil,
        placeholder2: String? = nil,
        priority: String? = nil,
        custom_data: JSON? = nil
    ) {
        self.name = name
        self.description = description
        self.image_url = image_url
        self.winner_template = winner_template
        self.not_winner_template = not_winner_template
        self.placeholder1 = placeholder1
        self.placeholder2 = placeholder2
        self.priority = priority
        self.custom_data = custom_data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.winner_template = try c.lenientObject(JackpotHtmlTemplate.self, "winner_template")
        self.not_winner_template = try c.lenientObject(JackpotHtmlTemplate.self, "not_winner_template")
        self.placeholder1 = try c.lenientString("placeholder1")
        self.placeholder2 = try c.lenientString("placeholder2")
        self.priority = try c.lenientString("priority")
        self.custom_data = try c.lenientJSON("custom_data")
    }
}
