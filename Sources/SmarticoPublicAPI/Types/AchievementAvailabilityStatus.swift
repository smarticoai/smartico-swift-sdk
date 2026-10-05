// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// Possible statuses of the mission availability.
///  Notes:
///   - Recurring missions have a special field next_recurrence_date_ts, but it's only relevant if the mission has no active till date or the next recurrence date is before the active till date.
///   - For a locked mission or mission that requires opt-in, the time limit should be calculated as dt_start + time_limit_ms. For a mission that does not require opt-in or type is not Locked, it should be the highest value of dt_start and active_from_ts (if defined) + time_limit_ms.
public enum AchievementAvailabilityStatus {
    public static let Available: Int64 = 0
    public static let AvailableInactive: Int64 = 1
    public static let AvailableActive: Int64 = 2
    public static let UnavailableWithActiveFrom: Int64 = 3
    public static let AvailableWithActiveTill: Int64 = 4
    public static let AvailableWithActiveTillInactive: Int64 = 5
    public static let AvailableWithActiveTillActive: Int64 = 6
    public static let AvailableLimited: Int64 = 7
    public static let AvailableLimitedInactive: Int64 = 8
    public static let AvailableLimitedActive: Int64 = 9
    public static let AvailableFullyLimited: Int64 = 10
    public static let AvailableFullyLimitedInactive: Int64 = 11
    public static let AvailableFullyLimitedActive: Int64 = 12
    public static let MissedByActiveTill: Int64 = 13
    public static let MissedByLimitInTime: Int64 = 14
}
