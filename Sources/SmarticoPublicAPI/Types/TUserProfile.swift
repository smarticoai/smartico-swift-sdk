// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TUser describes the information of the user
/// The user object is returned by Smartico.api.getUserProfile() method.
/// If you want to track the changes of the user profile, you can subscribe to the callback in the following way
///  Smartico.on('props_change', () => console.log(Smartico.api.getUserProfile()) );
public struct TUserProfile: Codable, Hashable, Sendable {
    /// Language code stored server-side for the user (e.g. `"en"`, `"de"`).
    public var core_user_language: String?
    /// Current spendable points balance — decremented by store purchases,
    /// tournament buy-ins, and clan entry fees.
    public var ach_points_balance: Int64?
    /// All-time cumulative points earned. Monotonic — NOT decremented by
    /// store purchases or clan/tournament fees.
    public var ach_points_ever: Int64?
    /// Current gems balance (secondary currency).
    public var ach_gems_balance: Double?
    /// Current diamonds balance (tertiary currency).
    public var ach_diamonds_balance: Double?
    /// Server-stored public tags on the user (uppercase strings).
    /// Modify via `Smartico.updatePublicTags(operation, tags)`.
    public var core_public_tags: [String]?
    /// FK into the level ladder; resolve via `getCurrentLevel()` or `getLevels()`.
    public var ach_level_current_id: Int64?
    /// `true` when the user is flagged as a test account.
    public var core_is_test_account: Bool?
    /// Resolved CDN URL for the user's avatar.
    public var avatar_url: String?
    /// Display username (operator-defined alias).
    public var public_username: String?
    /// Unread inbox messages count. Push-updated in real time.
    public var core_inbox_unread_count: Int64?
    /// AI-recommended deposit amount for this user. Undefined when no
    /// recommendation is currently available.
    public var core_recommended_deposit_amount: Double?
    /// AI-recommended casino bet amount for this user. Undefined when no
    /// recommendation is currently available.
    public var core_recommended_casino_bet_amount: Double?
    /// AI-recommended sport bet amount for this user. Undefined when no
    /// recommendation is currently available.
    public var core_recommended_sport_bet_amount: Double?
    /// Display name of the user's current level (e.g. `"Silver"`); resolve the id via `getCurrentLevel()`.
    public var ach_level_current: String?
    /// `true` when the user is in the gamification A/B control group (gamification UI suppressed).
    public var ach_gamification_in_control_group: Bool?
    /// Smartico-internal numeric user id.
    public var user_id: Int64?
    /// ISO country code of the user (e.g. `"BG"`).
    public var user_country: String?
    /// Wallet currency code (e.g. `"EUR"`).
    public var core_wallet_currency: String?
    /// Registration timestamp (epoch ms); `0` when unknown.
    public var core_registration_date: Int64?
    /// Last-session browser push-permission state (e.g. `"BLOCKED"`, `"GRANTED"`).
    public var user_last_session_push_state: String?
    /// `true` when the account is flagged as a bonus abuser.
    public var acc_bonus_abuser: Bool?
    /// Selected avatar id (catalogue avatar or AI-variant base).
    public var avatar_id: String?
    /// `avatar_real_id` of the selected avatar; `0` when none.
    public var avatar_real_id: Int64?
    /// `avatar_real_id` of the user's core avatar; null when unset.
    public var core_avatar_real_id: Int64?
    /// Current clan id (string); empty/null when not in a clan.
    public var core_clan_id: String?
    /// `true` when the user was kicked from their clan; null when not applicable.
    public var core_clan_is_kicked: Bool?
    /// Id of the clan the user was kicked from; null when not applicable.
    public var core_clan_kicked_out_id: Int64?
    /// ext_user_id of the friend who referred this user; null when none.
    public var aff_referred_by_friend_ext_user_id: String?
    /// Refer-a-friend share URL; null when the feature is disabled.
    public var aff_refer_friend_url: String?
    /// Count of friends this user has referred.
    public var aff_refered_friends_count: Int64?

    public init(
        core_user_language: String? = nil,
        ach_points_balance: Int64? = nil,
        ach_points_ever: Int64? = nil,
        ach_gems_balance: Double? = nil,
        ach_diamonds_balance: Double? = nil,
        core_public_tags: [String]? = nil,
        ach_level_current_id: Int64? = nil,
        core_is_test_account: Bool? = nil,
        avatar_url: String? = nil,
        public_username: String? = nil,
        core_inbox_unread_count: Int64? = nil,
        core_recommended_deposit_amount: Double? = nil,
        core_recommended_casino_bet_amount: Double? = nil,
        core_recommended_sport_bet_amount: Double? = nil,
        ach_level_current: String? = nil,
        ach_gamification_in_control_group: Bool? = nil,
        user_id: Int64? = nil,
        user_country: String? = nil,
        core_wallet_currency: String? = nil,
        core_registration_date: Int64? = nil,
        user_last_session_push_state: String? = nil,
        acc_bonus_abuser: Bool? = nil,
        avatar_id: String? = nil,
        avatar_real_id: Int64? = nil,
        core_avatar_real_id: Int64? = nil,
        core_clan_id: String? = nil,
        core_clan_is_kicked: Bool? = nil,
        core_clan_kicked_out_id: Int64? = nil,
        aff_referred_by_friend_ext_user_id: String? = nil,
        aff_refer_friend_url: String? = nil,
        aff_refered_friends_count: Int64? = nil
    ) {
        self.core_user_language = core_user_language
        self.ach_points_balance = ach_points_balance
        self.ach_points_ever = ach_points_ever
        self.ach_gems_balance = ach_gems_balance
        self.ach_diamonds_balance = ach_diamonds_balance
        self.core_public_tags = core_public_tags
        self.ach_level_current_id = ach_level_current_id
        self.core_is_test_account = core_is_test_account
        self.avatar_url = avatar_url
        self.public_username = public_username
        self.core_inbox_unread_count = core_inbox_unread_count
        self.core_recommended_deposit_amount = core_recommended_deposit_amount
        self.core_recommended_casino_bet_amount = core_recommended_casino_bet_amount
        self.core_recommended_sport_bet_amount = core_recommended_sport_bet_amount
        self.ach_level_current = ach_level_current
        self.ach_gamification_in_control_group = ach_gamification_in_control_group
        self.user_id = user_id
        self.user_country = user_country
        self.core_wallet_currency = core_wallet_currency
        self.core_registration_date = core_registration_date
        self.user_last_session_push_state = user_last_session_push_state
        self.acc_bonus_abuser = acc_bonus_abuser
        self.avatar_id = avatar_id
        self.avatar_real_id = avatar_real_id
        self.core_avatar_real_id = core_avatar_real_id
        self.core_clan_id = core_clan_id
        self.core_clan_is_kicked = core_clan_is_kicked
        self.core_clan_kicked_out_id = core_clan_kicked_out_id
        self.aff_referred_by_friend_ext_user_id = aff_referred_by_friend_ext_user_id
        self.aff_refer_friend_url = aff_refer_friend_url
        self.aff_refered_friends_count = aff_refered_friends_count
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.core_user_language = try c.lenientString("core_user_language")
        self.ach_points_balance = try c.lenientInt64("ach_points_balance")
        self.ach_points_ever = try c.lenientInt64("ach_points_ever")
        self.ach_gems_balance = try c.lenientDouble("ach_gems_balance")
        self.ach_diamonds_balance = try c.lenientDouble("ach_diamonds_balance")
        self.core_public_tags = try c.lenientList(String.self, "core_public_tags")
        self.ach_level_current_id = try c.lenientInt64("ach_level_current_id")
        self.core_is_test_account = try c.lenientBool("core_is_test_account")
        self.avatar_url = try c.lenientString("avatar_url")
        self.public_username = try c.lenientString("public_username")
        self.core_inbox_unread_count = try c.lenientInt64("core_inbox_unread_count")
        self.core_recommended_deposit_amount = try c.lenientDouble("core_recommended_deposit_amount")
        self.core_recommended_casino_bet_amount = try c.lenientDouble("core_recommended_casino_bet_amount")
        self.core_recommended_sport_bet_amount = try c.lenientDouble("core_recommended_sport_bet_amount")
        self.ach_level_current = try c.lenientString("ach_level_current")
        self.ach_gamification_in_control_group = try c.lenientBool("ach_gamification_in_control_group")
        self.user_id = try c.lenientInt64("user_id")
        self.user_country = try c.lenientString("user_country")
        self.core_wallet_currency = try c.lenientString("core_wallet_currency")
        self.core_registration_date = try c.lenientInt64("core_registration_date")
        self.user_last_session_push_state = try c.lenientString("user_last_session_push_state")
        self.acc_bonus_abuser = try c.lenientBool("acc_bonus_abuser")
        self.avatar_id = try c.lenientString("avatar_id")
        self.avatar_real_id = try c.lenientInt64("avatar_real_id")
        self.core_avatar_real_id = try c.lenientInt64("core_avatar_real_id")
        self.core_clan_id = try c.lenientString("core_clan_id")
        self.core_clan_is_kicked = try c.lenientBool("core_clan_is_kicked")
        self.core_clan_kicked_out_id = try c.lenientInt64("core_clan_kicked_out_id")
        self.aff_referred_by_friend_ext_user_id = try c.lenientString("aff_referred_by_friend_ext_user_id")
        self.aff_refer_friend_url = try c.lenientString("aff_refer_friend_url")
        self.aff_refered_friends_count = try c.lenientInt64("aff_refered_friends_count")
    }
}
