// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct LevelPublicMeta: Codable, Hashable, Sendable {
    /// Description of level, HTML capabable
    public var description: String?
    /// URL to the image of level
    public var image_url: String?
    /// Name of level
    public var name: String?
    /// Number of points that user should have collected in order to see this level
    public var visibility_points: Int64?
    /// X & Y coordinates of level on the visual mission map, for desktop and mobile
    public var position: JSON?
    /// Custom data as string or JSON string that can be used in API to build custom UI
    /// You can request from Smartico to define fields for your specific case that will be managed from Smartico BackOffice
    /// Read more here - https://help.smartico.ai/welcome/products/tools-and-guides/custom-fields-attributes
    public var custom_data: String?

    public init(
        description: String? = nil,
        image_url: String? = nil,
        name: String? = nil,
        visibility_points: Int64? = nil,
        position: JSON? = nil,
        custom_data: String? = nil
    ) {
        self.description = description
        self.image_url = image_url
        self.name = name
        self.visibility_points = visibility_points
        self.position = position
        self.custom_data = custom_data
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.name = try c.lenientString("name")
        self.visibility_points = try c.lenientInt64("visibility_points")
        self.position = try c.lenientJSON("position")
        self.custom_data = try c.lenientString("custom_data")
    }
}
