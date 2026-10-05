// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// UI configuration for a SAW (Spin-And-Win) mini-game template.
///
/// This interface is returned as the `saw_template_ui_definition` property of
/// {@link SAWTemplate} and {@link TMiniGameTemplate}.  It covers all visual,
/// behavioural and game-type-specific settings that the operator can configure
/// in the Back-Office for every mini-game variant (Spin the Wheel, Scratch Card,
/// Gift Box, MatchX / Quiz, Treasure Hunt, Lootbox, Voyager, Prize Drop, etc.).
public struct SAWTemplateUI: Codable, Hashable, Sendable {
    /// CSS skin key that selects the overall visual theme of the game.
    /// Resolved at runtime to the matching skin folder / CSS bundle.
    public var skin: String?
    /// Display name of the mini-game template shown to players and in the
    /// Back-Office listing.  Supports translations via
    /// `saw_template_ui_definition._translations.<lang>.name`.
    public var name: String?
    /// HTML-capable description / rules text shown to the player before or
    /// during the game.  Supports translations via
    /// `saw_template_ui_definition._translations.<lang>.description`.
    public var description: String?
    /// URL of the thumbnail image (typically 256 × 256 px) shown in
    /// mini-game selection lists and galleries.
    public var thumbnail: String?
    /// HTML-capable message shown to a player who has reached the maximum
    /// number of allowed attempts for the current period.
    /// Rendered when the server rejects a spin with
    /// `SAWSpinErrorCode.SAW_FAILED_MAX_SPINS_REACHED`.
    /// Supports translations via
    /// `saw_template_ui_definition._translations.<lang>.over_limit_message`.
    ///
    /// Only relevant when `max_spins_count` is configured on the template.
    public var over_limit_message: String?
    /// HTML-capable message shown when the player has no spin attempts or
    /// insufficient points / gems / diamonds to play.
    /// Supports translations via
    /// `saw_template_ui_definition._translations.<lang>.no_attempts_message`.
    ///
    /// Only relevant for buy-in types `Spins`, `Points`, `Gems`, or `Diamonds`.
    public var no_attempts_message: String?
    /// Number of prize sectors on the wheel or gift-box grid.
    /// For Spin-the-Wheel games the Back-Office enforces a range of 3 – 10.
    public var sectors_count: Int64?
    /// Relative display order of the mini-game within a list.
    /// Lower values appear first.  Configurable in the Back-Office
    /// "Priority" field (Advanced section).
    public var priority: Int64?
    /// When `true` the mini-game is **excluded from the widget's automatic
    /// game listing** and is only accessible when it is explicitly triggered
    /// via a Campaign Flow Builder action or accessed by deep links or triggered over the api.
    ///
    /// Back-Office label:
    /// _"Available only from campaign (won't be visible in the widget)"_
    public var flow_builder_only: Bool?
    /// URL of the full-bleed background image shown on desktop devices.
    /// Not used for Plinko and Coin Flip game types.
    public var background_image: String?
    /// URL of the full-bleed background image shown on mobile devices.
    /// Falls back to {@link background_image} when absent.
    /// Not used for Plinko and Coin Flip game types.
    public var background_image_mobile: String?
    /// URL of the audio file (MP3 / WAV) played as background music
    /// during gameplay.  Silenced when {@link disable_background_music}
    /// is `true` or the player has muted audio.
    public var background_sound: String?
    /// Volume level of the background music, expressed as a percentage
    /// in the range `0` – `100`.
    public var background_music_volume: Double?
    /// When `true`, background music is muted even if a
    /// {@link background_sound} URL is provided.
    /// Defaults to `true` in the Skin Editor preview scaffolding.
    public var disable_background_music: Bool?
    /// Duration in milliseconds of the spin animation before the result
    /// is revealed (e.g. `3000` = 3 seconds).
    /// Applies to Spin-the-Wheel and similar animated game types.
    public var spin_animation_duration: Int64?
    /// Rotation offset in degrees applied to the visual pointer / arrow
    /// on the wheel to compensate for skin-specific alignment differences.
    public var wheel_pointer_rotation: Double?
    /// Screen positioning of the wheel relative to the game panel.
    ///
    /// | Value | Meaning |
    /// | --- | --- |
    /// | `SAWWheelLayout.Centered = 1` | Wheel centred in the panel |
    /// | `SAWWheelLayout.LeftAligned = 2` | Wheel pinned to the left |
    /// | `SAWWheelLayout.RightAligned = 3` | Wheel pinned to the right |
    /// | `SAWWheelLayout.BottomAligned = 4` | Wheel pinned to the bottom |
    ///
    /// Applies to Spin-the-Wheel games only.
    /// Back-Office label: _"Wheel layout"_.
    public var wheel_layout: Int64?
    /// URL of the logo image overlaid on the scratch-card surface
    /// before the player scratches.
    public var scratch_logo: String?
    /// URL of the cover / foil image that the player scratches away
    /// to reveal the prize beneath.
    public var scratch_cover: String?
    /// URL of the background image shown behind the scratch card on
    /// desktop devices.
    /// Back-Office label: _"Scratch main desktop background"_.
    public var scratch_bg_desktop: String?
    /// URL of the background image shown behind the scratch card on
    /// mobile devices.
    /// Back-Office label: _"Scratch main mobile background"_.
    public var scratch_bg_mobile: String?
    /// URL of a custom cursor image used when the pointer hovers over
    /// the scratchable area.
    /// Back-Office label: _"Scratch mouse cursor"_.
    public var scratch_cursor: String?
    /// When `true`, prize / reward names are hidden inside the scratch-card
    /// UI so the player does not know what they won until they have fully
    /// scratched the card.
    ///
    /// Only rendered for `SAWGameType.ScratchCard`.
    /// Back-Office label: _"Hide prize names"_.
    public var hide_prize_names: Bool?
    /// Raw CSS injected into the game iframe, allowing fine-grained
    /// overrides beyond what the selected skin provides.
    public var custom_css: String?
    /// Path to an alternative folder from which skin assets (images,
    /// CSS, client) are loaded instead of the default skin bundle.
    public var custom_skin_folder: String?
    /// Label / symbol appended to the jackpot amount to give it semantic
    /// meaning (e.g. `"EUR"`, `"Free spins"`).
    /// Displayed alongside {@link SAWTemplate.jackpot_current}.
    /// Back-Office label: _"Jackpot symbol"_.
    public var jackpot_symbol: String?
    /// URL of a promotional banner image (recommended 500 × 240 px)
    /// displayed inside the game UI to advertise an offer or campaign.
    /// Supports per-language variants via
    /// `saw_template_ui_definition.promo_image_<lang>`.
    public var promo_image: String?
    /// HTML-capable promotional text displayed alongside
    /// {@link promo_image}.  Supports translations via
    /// `saw_template_ui_definition._translations.<lang>.promo_text`.
    public var promo_text: String?
    /// URL of the banner image shown at the top of the MatchX / Quiz
    /// tournament leaderboard on desktop.
    /// Back-Office label: _"Banner"_.
    public var matchx_banner: String?
    /// URL of the mobile-optimised banner image for the MatchX / Quiz
    /// tournament leaderboard.
    public var matchx_banner_mobile: String?
    /// When `true`, tournament rankings are reset on a seasonal cadence
    /// rather than being continuous.
    public var matchx_seasonal_ranking: Bool?
    /// When `true`, the MatchX / Quiz tournament has concluded.
    /// New entries are blocked and the final leaderboard is shown.
    public var matchx_is_completed: Bool?
    /// Maximum number of players visible on the general leaderboard
    /// inside the MatchX / Quiz game.
    public var matchx_general_board_users_count: Int64?
    /// When `true`, the ranking / leaderboard panel is hidden from
    /// players inside the MatchX / Quiz game.
    /// Back-Office label: _"Hide ranking"_.
    public var matchx_hide_ranking: Bool?
    /// URL of an image used to illustrate the prize pool (e.g. a trophy
    /// or coins graphic).
    public var prize_pool_image: String?
    /// When `true`, a panel listing the available prizes is displayed
    /// inside the game.
    ///
    /// Back-Office label: _"Show the list of the prizes"_.
    /// Defaults to `true` in the MatchX / Quiz game form.
    public var show_prize_board: Bool?
    /// The rolling time-window in milliseconds within which
    /// `SAWTemplate.maxSpinsCount` attempts are allowed
    /// (e.g. `86400000` = 24 hours).
    ///
    /// Stored on the template root as `max_spins_period_ms`; mirrored here
    /// for convenience in UI preview payloads.
    public var max_spins_period_ms: Int64?
    /// When `true`, a countdown timer showing when the next spin becomes
    /// available is displayed to the player.
    ///
    /// Only active when `max_spins_count === 1` **and** `max_spins_period_ms`
    /// is set; automatically forced to `false`.
    ///
    /// Back-Office label: _"Show time to the next available spin"_.
    public var show_countdown_for_next_availability: Bool?
    /// Controls when (or whether) the player is asked to provide a
    /// display name before or after playing.
    ///
    /// | Value | Meaning |
    /// | --- | --- |
    /// | `SAWAskForUsername.NOASK = 'no-ask'` | Never ask |
    /// | `SAWAskForUsername.ONSUMBIT = 'on-submit'` | Ask when submitting |
    ///
    /// Back-Office label: _"Ask for username"_.
    public var ask_for_username: String?
    /// ID of the custom section (category / tab) this mini-game belongs to,
    /// allowing operators to group games in bespoke widget sections.
    /// Back-Office label: _"Custom section"_.
    public var custom_section_id: Int64?
    /// When `true`, the template is shown **only** inside its assigned
    /// custom section and is suppressed from all standard game listings.
    public var only_in_custom_section: Bool?
    /// Determines which identifier is forwarded in webhooks and the
    /// Retention API when a spin result is produced.
    ///
    /// | Value | Meaning |
    /// | --- | --- |
    /// | `SAWExposeUserSpinId.UserId = 1` | Expose the operator's external user ID |
    /// | `SAWExposeUserSpinId.SpinId = 2` | Expose the internal spin transaction ID |
    ///
    /// Back-Office label:
    /// _"Expose 'External user ID' or 'Spin transaction ID'"_.
    public var expose_user_spin_id: Int64?
    /// Arbitrary operator-defined payload attached to the template.
    /// Can be a JSON object, plain string, or number.  Passed through to
    /// the front-end as-is and accessible via the public API.
    /// Back-Office label: _"Custom data field"_.
    public var custom_data: JSON?
    /// First free-form placeholder string used by Prize Drop game skins
    /// to inject operator-defined copy into the game UI.
    public var placeholder1: String?
    /// Second free-form placeholder string used by Prize Drop game skins
    /// to inject operator-defined copy into the game UI.
    public var placeholder2: String?
    /// Template definition for the Prize Drop game overlay.
    /// `id` is the unique template identifier; `content` is the raw HTML
    /// rendered inside the drop panel.
    public var prize_drop_template: JSON?
    /// Visual arrangement of items in Lootbox (Weekly / Calendar Days)
    /// game types.
    ///
    /// | Value | Meaning |
    /// | --- | --- |
    /// | `SAWGameLayout.Horizontal = 1` | Items laid out in a horizontal row |
    /// | `SAWGameLayout.VerticalMap = 2` | Items arranged as a vertical map path |
    ///
    /// Back-Office label: _"Visual layout"_.
    public var game_layout: Int64?
    /// Total number of path steps / cells a player must progress through
    /// to complete a Treasure Hunt game and receive the final prize.
    /// Higher values result in longer gameplay sessions.
    /// Back-Office label: _"Steps to finish game"_.
    public var steps_to_finish_game: Double?
    /// Minimum number of path steps / collectible prizes a Voyager session
    /// must include before the game can finish.  Acts as a floor for the
    /// randomly-chosen path length so that sessions cannot terminate after
    /// only one or two prizes.  When omitted, no minimum is enforced.
    /// Must be `>= 1` and `<= steps_to_finish_game`.
    /// Back-Office label: _"Min. number of prizes"_.
    public var min_steps_to_finish_game: Double?
    /// Difficulty level of the Voyager (space-exploration) mini-game,
    /// controlling obstacle frequency and game speed.
    ///
    /// | Value | Meaning |
    /// | --- | --- |
    /// | `SAWGameDifficultyType.EASY = 1` | Easy |
    /// | `SAWGameDifficultyType.MEDIUM = 2` | Medium |
    /// | `SAWGameDifficultyType.HARD = 3` | Hard |
    public var game_difficulty: Int64?
    /// URL of the operator-hosted custom mini-game, loaded inside an iframe by
    /// the widget for `SAWGameType.CustomMinigame`.  The operator is trusted
    /// (the URL resolves to the operator's own published Vibe Studio game), but
    /// the iframe is still rendered with a restrictive sandbox as defence in
    /// depth: `sandbox="allow-scripts allow-forms allow-same-origin allow-popups
    /// allow-pointer-lock"`. Top-level navigation is intentionally not allowed,
    /// so the game cannot redirect the host page.
    /// Back-Office label: _"Game URL"_.
    public var custom_game_url: String?
    /// Whether this template is played as a custom mini-game.
    ///
    /// A template of any regular game type (wheel, scratch card, treasure hunt,
    /// …) can be switched over to a custom game while keeping its own type,
    /// prizes and buy-in settings — only the way it is played changes: the
    /// widget loads `custom_game_url` in an iframe instead of rendering the
    /// built-in game.  `saw_game_type_id` still reports the original type, so
    /// treat this flag — not the type — as the answer to "is this played as a
    /// custom game", together with `SAWGameType.CustomMinigame`, which is always
    /// played that way.
    ///
    /// When `false` or omitted, the template is played as its own game type.
    /// Back-Office label: _"Use Custom Game"_.
    public var use_custom: Bool?
    /// Whether a custom mini-game fills the whole mini-game window instead of
    /// the default fixed-size frame (800×516 on desktop, 400×745 on mobile).
    ///
    /// Applies wherever the game is opened — a spin attempt shown to the user,
    /// a deep link, or `Smartico.miniGame()` in standalone or inline mode.
    /// The `fullscreen` option of `Smartico.miniGame()` overrides it per call.
    ///
    /// When `false` or omitted, the default frame size is used.
    /// Back-Office label: _"Standalone full screen"_.
    public var standalone_fullscreen: Bool?
    /// Width of the custom mini-game frame on desktop when opened standalone or inline,
    /// as a CSS size (`800px`, `100%`, `90vw`; a bare number is treated as pixels).
    /// Empty or invalid values fall back to the default 800px. Ignored on mobile.
    /// Back-Office label: _"Standalone width"_.
    public var standalone_width: String?
    /// Height of the custom mini-game frame on desktop when opened standalone or inline,
    /// as a CSS size (`516px`, `100%`, `90vh`; a bare number is treated as pixels).
    /// Empty or invalid values fall back to the default 516px. Ignored on mobile.
    /// Back-Office label: _"Standalone height"_.
    public var standalone_height: String?
    /// Minutes for the Voyager seed window.
    /// The seed window is the range of seeds that can be used to generate the map.
    /// The seed window is used to ensure that the map is generated the same way for each player.
    public var voyager_seed_window_min: Double?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var custom_section_menu_img: String?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var relative_period_timezone: Int64?
    /// Sent by the server but absent from the TS declaration (parity fix).
    public var weekdays: [Int64]?

    public init(
        skin: String? = nil,
        name: String? = nil,
        description: String? = nil,
        thumbnail: String? = nil,
        over_limit_message: String? = nil,
        no_attempts_message: String? = nil,
        sectors_count: Int64? = nil,
        priority: Int64? = nil,
        flow_builder_only: Bool? = nil,
        background_image: String? = nil,
        background_image_mobile: String? = nil,
        background_sound: String? = nil,
        background_music_volume: Double? = nil,
        disable_background_music: Bool? = nil,
        spin_animation_duration: Int64? = nil,
        wheel_pointer_rotation: Double? = nil,
        wheel_layout: Int64? = nil,
        scratch_logo: String? = nil,
        scratch_cover: String? = nil,
        scratch_bg_desktop: String? = nil,
        scratch_bg_mobile: String? = nil,
        scratch_cursor: String? = nil,
        hide_prize_names: Bool? = nil,
        custom_css: String? = nil,
        custom_skin_folder: String? = nil,
        jackpot_symbol: String? = nil,
        promo_image: String? = nil,
        promo_text: String? = nil,
        matchx_banner: String? = nil,
        matchx_banner_mobile: String? = nil,
        matchx_seasonal_ranking: Bool? = nil,
        matchx_is_completed: Bool? = nil,
        matchx_general_board_users_count: Int64? = nil,
        matchx_hide_ranking: Bool? = nil,
        prize_pool_image: String? = nil,
        show_prize_board: Bool? = nil,
        max_spins_period_ms: Int64? = nil,
        show_countdown_for_next_availability: Bool? = nil,
        ask_for_username: String? = nil,
        custom_section_id: Int64? = nil,
        only_in_custom_section: Bool? = nil,
        expose_user_spin_id: Int64? = nil,
        custom_data: JSON? = nil,
        placeholder1: String? = nil,
        placeholder2: String? = nil,
        prize_drop_template: JSON? = nil,
        game_layout: Int64? = nil,
        steps_to_finish_game: Double? = nil,
        min_steps_to_finish_game: Double? = nil,
        game_difficulty: Int64? = nil,
        custom_game_url: String? = nil,
        use_custom: Bool? = nil,
        standalone_fullscreen: Bool? = nil,
        standalone_width: String? = nil,
        standalone_height: String? = nil,
        voyager_seed_window_min: Double? = nil,
        custom_section_menu_img: String? = nil,
        relative_period_timezone: Int64? = nil,
        weekdays: [Int64]? = nil
    ) {
        self.skin = skin
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.over_limit_message = over_limit_message
        self.no_attempts_message = no_attempts_message
        self.sectors_count = sectors_count
        self.priority = priority
        self.flow_builder_only = flow_builder_only
        self.background_image = background_image
        self.background_image_mobile = background_image_mobile
        self.background_sound = background_sound
        self.background_music_volume = background_music_volume
        self.disable_background_music = disable_background_music
        self.spin_animation_duration = spin_animation_duration
        self.wheel_pointer_rotation = wheel_pointer_rotation
        self.wheel_layout = wheel_layout
        self.scratch_logo = scratch_logo
        self.scratch_cover = scratch_cover
        self.scratch_bg_desktop = scratch_bg_desktop
        self.scratch_bg_mobile = scratch_bg_mobile
        self.scratch_cursor = scratch_cursor
        self.hide_prize_names = hide_prize_names
        self.custom_css = custom_css
        self.custom_skin_folder = custom_skin_folder
        self.jackpot_symbol = jackpot_symbol
        self.promo_image = promo_image
        self.promo_text = promo_text
        self.matchx_banner = matchx_banner
        self.matchx_banner_mobile = matchx_banner_mobile
        self.matchx_seasonal_ranking = matchx_seasonal_ranking
        self.matchx_is_completed = matchx_is_completed
        self.matchx_general_board_users_count = matchx_general_board_users_count
        self.matchx_hide_ranking = matchx_hide_ranking
        self.prize_pool_image = prize_pool_image
        self.show_prize_board = show_prize_board
        self.max_spins_period_ms = max_spins_period_ms
        self.show_countdown_for_next_availability = show_countdown_for_next_availability
        self.ask_for_username = ask_for_username
        self.custom_section_id = custom_section_id
        self.only_in_custom_section = only_in_custom_section
        self.expose_user_spin_id = expose_user_spin_id
        self.custom_data = custom_data
        self.placeholder1 = placeholder1
        self.placeholder2 = placeholder2
        self.prize_drop_template = prize_drop_template
        self.game_layout = game_layout
        self.steps_to_finish_game = steps_to_finish_game
        self.min_steps_to_finish_game = min_steps_to_finish_game
        self.game_difficulty = game_difficulty
        self.custom_game_url = custom_game_url
        self.use_custom = use_custom
        self.standalone_fullscreen = standalone_fullscreen
        self.standalone_width = standalone_width
        self.standalone_height = standalone_height
        self.voyager_seed_window_min = voyager_seed_window_min
        self.custom_section_menu_img = custom_section_menu_img
        self.relative_period_timezone = relative_period_timezone
        self.weekdays = weekdays
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.skin = try c.lenientString("skin")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.thumbnail = try c.lenientString("thumbnail")
        self.over_limit_message = try c.lenientString("over_limit_message")
        self.no_attempts_message = try c.lenientString("no_attempts_message")
        self.sectors_count = try c.lenientInt64("sectors_count")
        self.priority = try c.lenientInt64("priority")
        self.flow_builder_only = try c.lenientBool("flow_builder_only")
        self.background_image = try c.lenientString("background_image")
        self.background_image_mobile = try c.lenientString("background_image_mobile")
        self.background_sound = try c.lenientString("background_sound")
        self.background_music_volume = try c.lenientDouble("background_music_volume")
        self.disable_background_music = try c.lenientBool("disable_background_music")
        self.spin_animation_duration = try c.lenientInt64("spin_animation_duration")
        self.wheel_pointer_rotation = try c.lenientDouble("wheel_pointer_rotation")
        self.wheel_layout = try c.lenientInt64("wheel_layout")
        self.scratch_logo = try c.lenientString("scratch_logo")
        self.scratch_cover = try c.lenientString("scratch_cover")
        self.scratch_bg_desktop = try c.lenientString("scratch_bg_desktop")
        self.scratch_bg_mobile = try c.lenientString("scratch_bg_mobile")
        self.scratch_cursor = try c.lenientString("scratch_cursor")
        self.hide_prize_names = try c.lenientBool("hide_prize_names")
        self.custom_css = try c.lenientString("custom_css")
        self.custom_skin_folder = try c.lenientString("custom_skin_folder")
        self.jackpot_symbol = try c.lenientString("jackpot_symbol")
        self.promo_image = try c.lenientString("promo_image")
        self.promo_text = try c.lenientString("promo_text")
        self.matchx_banner = try c.lenientString("matchx_banner")
        self.matchx_banner_mobile = try c.lenientString("matchx_banner_mobile")
        self.matchx_seasonal_ranking = try c.lenientBool("matchx_seasonal_ranking")
        self.matchx_is_completed = try c.lenientBool("matchx_is_completed")
        self.matchx_general_board_users_count = try c.lenientInt64("matchx_general_board_users_count")
        self.matchx_hide_ranking = try c.lenientBool("matchx_hide_ranking")
        self.prize_pool_image = try c.lenientString("prize_pool_image")
        self.show_prize_board = try c.lenientBool("show_prize_board")
        self.max_spins_period_ms = try c.lenientInt64("max_spins_period_ms")
        self.show_countdown_for_next_availability = try c.lenientBool("show_countdown_for_next_availability")
        self.ask_for_username = try c.lenientString("ask_for_username")
        self.custom_section_id = try c.lenientInt64("custom_section_id")
        self.only_in_custom_section = try c.lenientBool("only_in_custom_section")
        self.expose_user_spin_id = try c.lenientInt64("expose_user_spin_id")
        self.custom_data = try c.lenientJSON("custom_data")
        self.placeholder1 = try c.lenientString("placeholder1")
        self.placeholder2 = try c.lenientString("placeholder2")
        self.prize_drop_template = try c.lenientJSON("prize_drop_template")
        self.game_layout = try c.lenientInt64("game_layout")
        self.steps_to_finish_game = try c.lenientDouble("steps_to_finish_game")
        self.min_steps_to_finish_game = try c.lenientDouble("min_steps_to_finish_game")
        self.game_difficulty = try c.lenientInt64("game_difficulty")
        self.custom_game_url = try c.lenientString("custom_game_url")
        self.use_custom = try c.lenientBool("use_custom")
        self.standalone_fullscreen = try c.lenientBool("standalone_fullscreen")
        self.standalone_width = try c.lenientString("standalone_width")
        self.standalone_height = try c.lenientString("standalone_height")
        self.voyager_seed_window_min = try c.lenientDouble("voyager_seed_window_min")
        self.custom_section_menu_img = try c.lenientString("custom_section_menu_img")
        self.relative_period_timezone = try c.lenientInt64("relative_period_timezone")
        self.weekdays = try c.lenientList(Int64.self, "weekdays")
    }
}
