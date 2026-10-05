// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Limit error codes returned in `errCode` by the `avatarsCustomize` method.
/// See the `avatarsCustomize` TSDoc for the full table (including the generic
/// `-1` failure, which has no named member here).
public enum AvatarCustomizeErrorCode {
    public static let AVATAR_USER_LIMIT: Int64 = 12001
    public static let AVATAR_LABEL_LIMIT: Int64 = 12002
}
