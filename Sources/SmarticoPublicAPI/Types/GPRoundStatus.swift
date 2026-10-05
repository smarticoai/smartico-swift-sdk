// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// GPRoundStatus defines the lifecycle stage of a game round
public enum GPRoundStatus {
    public static let Other: Int64 = -1
    public static let NoEventsDefined: Int64 = 1
    public static let NoMoreBetsAllowed: Int64 = 2
    public static let AllEventsResolved_ButNotRound: Int64 = 3
    public static let RoundResolved: Int64 = 4
}
