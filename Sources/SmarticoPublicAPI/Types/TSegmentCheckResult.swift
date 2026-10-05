// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TSegmentCheckResult describes one segment-membership outcome.
/// Returned by `Smartico.api.checkSegmentListMatch()` (and used
/// internally by `checkSegmentMatch()`).
public struct TSegmentCheckResult: Codable, Hashable, Sendable {
    /// The segment ID this result refers to (label-scoped).
    public var segment_id: Int64?
    /// `true` if the user currently matches this segment. `false` also
    /// covers the case where the segment doesn't exist for the label —
    /// the two are not distinguishable.
    public var is_matching: Bool?

    public init(
        segment_id: Int64? = nil,
        is_matching: Bool? = nil
    ) {
        self.segment_id = segment_id
        self.is_matching = is_matching
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.segment_id = try c.lenientInt64("segment_id")
        self.is_matching = try c.lenientBool("is_matching")
    }
}
