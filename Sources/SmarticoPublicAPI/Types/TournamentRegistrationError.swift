// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Error codes returned in `err_code` by the `registerInTournament` method.
///
/// These are terse value definitions for lookup. The full per-code narrative —
/// when each fires and how the consumer's UI should react — lives in the
/// `registerInTournament` method TSDoc, which owns the error table.
///
/// Note the numbering break: the gems / diamonds codes are 6-digit
/// (`300010` / `300011`) while the rest of the tournament block is 5-digit;
/// they were appended after the original `30001`–`30009` range was occupied.
/// Branch on the exact numeric value, not on digit count.
public enum TournamentRegistrationError {
    public static let NO_ERROR: Int64 = 0
    public static let TOURNAMENT_USER_CANNOT_JOIN_WITHOUT_CLAN: Int64 = 1010
    public static let TOURNAMENT_INSTANCE_NOT_FOUND: Int64 = 30001
    public static let TOURNAMENT_REGISTRATION_NOT_ENOUGH_POINTS: Int64 = 30002
    public static let TOURNAMENT_INSTANCE_NOT_IN_STATE: Int64 = 30003
    public static let TOURNAMENT_ALREADY_REGISTERED: Int64 = 30004
    public static let TOURNAMENT_USER_DONT_MATCH_CONDITIONS: Int64 = 30005
    public static let TOURNAMENT_USER_NOT_REGISTERED: Int64 = 30006
    public static let TOURNAMENT_CANT_CHANGE_REGISTRATION_STATUS: Int64 = 30007
    public static let TOURNAMENT_MAX_REGISTRATIONS_REACHED: Int64 = 30008
    public static let TOURNAMENT_INVALID_USER_CURRENCY: Int64 = 30009
    public static let TOURNAMENT_REGISTRATION_NOT_ENOUGH_GEMS: Int64 = 300010
    public static let TOURNAMENT_REGISTRATION_NOT_ENOUGH_DIAMONDS: Int64 = 300011
}
