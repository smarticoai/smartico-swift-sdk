// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct JackpotHtmlTemplate: Codable, Hashable, Sendable {
    public var id: String?
    public var content: String?

    public init(
        id: String? = nil,
        content: String? = nil
    ) {
        self.id = id
        self.content = content
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientString("id")
        self.content = try c.lenientString("content")
    }
}
