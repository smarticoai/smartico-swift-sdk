// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Result of `getTranslations(lang_code)`.
public struct TGetTranslations: Codable, Hashable, Sendable {
    /// Flat dictionary of operator-defined translation key → translated string.
    public var translations: JSON?

    public init(
        translations: JSON? = nil
    ) {
        self.translations = translations
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.translations = try c.lenientJSON("translations")
    }
}
