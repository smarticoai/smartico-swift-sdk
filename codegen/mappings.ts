/**
 * Hand-maintained rules for cases the mechanical TS→Swift mapping can't
 * decide on its own. Everything else is derived from the declarations.
 */

/**
 * TypeScript's `number` is both Int and Double, so every numeric field needs a
 * decision. Getting it wrong is not cosmetic: an id decoded as Double renders
 * as 1.37861765E8, and a fraction decoded into an integral field is truncated.
 *
 * Rule: names that are counters/ids/timestamps are integral (Int64 — some ids
 * exceed Int32 range, e.g. engagement_id 97991759604); everything else is Double.
 */
export const INTEGRAL_NAME_PATTERNS: RegExp[] = [
  /_id$/i, /^id$/i, /_ids$/i,
  /^err_?code$/i, // error codes are integral everywhere; keep one Swift type
  /count$/i, /_num$/i, /^num_/i,
  /_date$/i, /^dt_/i, /_ts$/i, /_time$/i, /timestamp/i, /_ms$/i, /duration/i,
  /points/i, /_index$/i, /position/i, /order$/i, /priority/i,
  /level/i, /tickets/i, /_status$/i, /_type$/i, /version/i, /seconds/i, /days/i,
];

/** Per-type field overrides when the name heuristic is wrong: "TType.field": "SwiftType". */
export const FIELD_TYPE_OVERRIDES: Record<string, string> = {
  // The wire carries modifier LABELS ("2x", "/5"), not the numeric enum the
  // declaration suggests — verified against live env4 payloads.
  'SAWPrizeUI.prize_modifiers': '[String]',
  'TMiniGamePrize.prize_modifiers': '[String]',
  // Declared `string`, but the SDK parses JSON-looking values before handing
  // them out (the declaration's own doc admits it's `any` at runtime).
  'TLevel.custom_data': 'JSON',
  'TInboxMessageBody.custom_data': 'JSON',
};

/**
 * Inline object literals worth a real Swift type.
 *
 * The declarations spell some payloads out anonymously (`players?: { … }[]`).
 * Those degrade to JSON, which forces every consumer to hand-parse a
 * leaderboard row. Naming one here makes the generator emit a struct from
 * the very same members, so the Swift side is typed exactly like the JS one.
 */
export const INLINE_TYPES: Record<string, string> = {
  'TTournamentDetailed.players': 'TTournamentPlayer',
  'TTournamentDetailed.me': 'TTournamentMe',
  'TTournamentDetailed.prizes': 'TTournamentPrize',
  'TTournament.me': 'TTournamentMe',
  'TTournament.prizes': 'TTournamentPrize',
  'TTournamentDetailed.clan_leaderboard': 'TTournamentClanRank',
};

/**
 * Fields the server actually sends but the TypeScript declarations omit. The
 * JS SDK still surfaces them (it passes raw objects through), so a typed port
 * must declare them or it silently drops data — each one here was caught by
 * the JS/Kotlin parity check.
 */
export const EXTRA_FIELDS: Record<string, Record<string, string>> = {
  TMissionOrBadgeTask: {
    display_progress_as_count: 'Bool',
    stage_image: 'String',
    priority: 'Int64',
  },
  BonusTemplateMetaMap: {
    name: 'String',
  },
  SAWTemplateUI: {
    custom_section_menu_img: 'String',
    relative_period_timezone: 'Int64',
    weekdays: '[Int64]',
  },
};

/** Declarations to skip entirely (SDK-internal, not part of the data model). */
export const SKIP_DECLARATIONS = new Set<string>([
  'ILogger',
  'CookieStore',
  // Web-embed plumbing: these describe the object a web page gets on `window`
  // and the parameters of the embedded widget. Nothing in this SDK exposes
  // them, and generating them would ship types a Swift app can never use.
  'SmarticoGlobal',
  'SmarticoWidgetType',
  'SmarticoWidgetParams',
  'SmarticoInitParams',
]);
