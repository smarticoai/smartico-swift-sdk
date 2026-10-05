// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Error codes returned in `errCode` by the `joinClan` method (also carried
/// on `TClanJoinResult`). These are terse value definitions for lookup; the
/// full per-code narrative and UI handling lives in the `joinClan` method
/// TSDoc, which owns the error table.
public enum JoinClanErrorCode {
    public static let JOIN_CLAN_OK: Int64 = 0
    public static let JOIN_CLAN_INVALID_PARAMETERS: Int64 = 1000
    public static let JOIN_CLAN_NOT_FOUND: Int64 = 1001
    public static let JOIN_CLAN_FULL: Int64 = 1002
    public static let JOIN_CLAN_INSUFFICIENT_FUNDS: Int64 = 1003
    public static let JOIN_CLAN_SEGMENT_MISMATCH: Int64 = 1004
    public static let JOIN_CLAN_USER_IS_NOT_IN_CLAN: Int64 = 1005
    public static let JOIN_CLAN_COOLDOWN_ACTIVE: Int64 = 1006
    public static let JOIN_CLAN_JOINED_AFTER_TOURNAMENT_START: Int64 = 1011
}
