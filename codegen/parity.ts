/**
 * Field-parity check: feeds the SAME raw server payload (captured by the Swift
 * side, Tools/ParityDump) to the official transform from @smartico/public-api
 * and to our Swift transform's output, then diffs them field by field.
 *
 * Answers "do all the fields match?" with evidence instead of eyeballing.
 *
 * The capture is `<domain>.raw.json` + `<domain>.swift.json` + `meta.json`,
 * written by `swift run ParityDump`.
 *
 * Usage (from the repo root, credentials in the environment):
 *        swift run ParityDump
 *        cd codegen && npm run parity
 */
import * as fs from 'fs';
import * as path from 'path';
import * as api from '@smartico/public-api';

// `swift run ParityDump` writes ./build/parity relative to the repo root.
const DIR = path.join(__dirname, '..', 'build', 'parity');

/**
 * The capture records which environment it came from. Reading the image host
 * from there instead of hardcoding it means a dump taken against any label
 * diffs correctly — avatar transforms expand avatar_id against this domain, so
 * a wrong guess makes every row look like a mismatch.
 */
const META = path.join(DIR, 'meta.json');
if (!fs.existsSync(META)) {
  console.error(`No capture in ${path.relative(process.cwd(), DIR)} — run 'swift run ParityDump' in the repo root first.`);
  process.exit(1);
}
const AVATAR_DOMAIN: string = JSON.parse(fs.readFileSync(META, 'utf8')).avatar_domain;

/** How to turn each captured raw response into the JS SDK's public shape. */
const DOMAINS: Record<string, (raw: any) => any> = {
  levels: (raw) => (api as any).GetLevelMapResponseTransform(raw),
  missions: (raw) => (api as any).UserAchievementTransform((raw.achievements || []).filter((a: any) => a.ach_type_id === 1)),
  badges: (raw) => (api as any).UserAchievementTransform(
    (api as any).enrichUserAchievementsWithBadgeState((raw.achievements || []).filter((a: any) => a.ach_type_id === 2)),
  ),
  tournaments: (raw) => (api as any).TournamentItemsTransform(raw.tournaments || []),
  minigames: (raw) => (api as any).SAWTemplatesTransform(raw.templates || []),
  raffles: (raw) => (api as any).raffleTransform(raw.items || []),
  store: (raw) => (api as any).StoreItemTransform(raw.items || []),
  inbox: (raw) => (api as any).InboxMessagesTransform(raw.log || []),
  avatars: (raw) => (api as any).avatarDefinitionTransform(raw.avatars || [], AVATAR_DOMAIN),
  prompts: (raw) => (api as any).avatarPromptTransform(raw.prompts || [], AVATAR_DOMAIN),
  customized: (raw) => (api as any).avatarCustomizedTransform(raw.avatars || [], AVATAR_DOMAIN),
  bonuses: (raw) => (api as any).BonusItemsTransform(raw.bonuses || []),
  // clansGetListT just re-shapes the response, there is no exported transform
  clans: (raw) => ({
    clans: raw.clans,
    user_clan_id: raw.user_clan_id,
    cooldown_until: raw.cooldown_until,
    join_date: raw.join_date ?? null,
  }),
  leaderboard: (raw) => {
    const key = Object.keys(raw.map || {})[0];
    if (key === undefined) return null;
    const board = raw.map[key];
    // SmarticoAPI.leaderboardGet() expands avatar_id → avatar_url BEFORE the
    // transform; do the same here or every row looks like an extra.
    const withAvatar = (p: any) => {
      if (p && p.avatar_id) p.avatar_url = (api as any).CoreUtils.avatarUrl(p.avatar_id, AVATAR_DOMAIN);
      return p;
    };
    (board.positions || []).forEach(withAvatar);
    withAvatar(board.userPosition);
    return (api as any).getLeaderBoardTransform(board);
  },
};

const isEmpty = (v: any) => v === undefined || v === null || (Array.isArray(v) && v.length === 0);

/** Same value? Numbers compare numerically (5 vs 5.0); empty ≈ empty. */
function same(a: any, b: any): boolean {
  if (isEmpty(a) && isEmpty(b)) return true;
  if (typeof a === 'number' || typeof b === 'number') {
    const na = Number(a), nb = Number(b);
    if (!Number.isNaN(na) && !Number.isNaN(nb)) return Math.abs(na - nb) < 1e-9;
  }
  if (typeof a === 'boolean' || typeof b === 'boolean') return Boolean(a) === Boolean(b);
  // Deep, key-order-insensitive: the Swift encoder sorts keys,
  // JS in assignment order — comparing serialized text would flag everything.
  if (typeof a === 'object' && typeof b === 'object') {
    if (Array.isArray(a) !== Array.isArray(b)) return false;
    if (Array.isArray(a)) {
      if (a.length !== b.length) return false;
      return a.every((x, i) => same(x, b[i]));
    }
    const keys = new Set([...Object.keys(a ?? {}), ...Object.keys(b ?? {})]);
    return [...keys].every((k) => same(a?.[k], b?.[k]));
  }
  return String(a) === String(b);
}

type Diff = { key: string; js: any; swift: any; kind: 'missing' | 'extra' | 'value' };

/** Reports LEAF differences: nested objects/arrays are drilled into so the
 * output names the actual field (`prizes[].icon`), not just the container. */
function diffObject(js: any, kt: any, prefix = ''): Diff[] {
  const out: Diff[] = [];
  if (js == null && kt == null) return out;

  // arrays: compare element-wise, collapsing the index so one bad field in 30
  // items reports once as `prizes[].icon`
  if (Array.isArray(js) && Array.isArray(kt)) {
    if (js.length !== kt.length) {
      out.push({ key: prefix.replace(/\.$/, '') + ' (length)', js: js.length, swift: kt.length, kind: 'value' });
    }
    for (let i = 0; i < Math.min(js.length, kt.length); i++) {
      out.push(...diffObject(js[i], kt[i], prefix.replace(/\.$/, '') + '[].'));
    }
    return out;
  }

  const keys = new Set([...Object.keys(js ?? {}), ...Object.keys(kt ?? {})]);
  for (const k of keys) {
    const a = js?.[k], b = kt?.[k];
    if (same(a, b)) continue;
    const key = prefix + k;
    const bothStructured = a && b && typeof a === 'object' && typeof b === 'object';
    if (bothStructured) {
      out.push(...diffObject(a, b, key + '.'));
      continue;
    }
    // one side has data, the other doesn't → a dropped/extra field
    if (!isEmpty(a) && isEmpty(b)) out.push({ key, js: a, swift: b, kind: 'missing' });
    else if (isEmpty(a) && !isEmpty(b)) out.push({ key, js: a, swift: b, kind: 'extra' });
    else out.push({ key, js: a, swift: b, kind: 'value' });
  }
  return out;
}

function short(v: any): string {
  const s = typeof v === 'object' ? JSON.stringify(v) : String(v);
  return s.length > 70 ? s.slice(0, 70) + '…' : s;
}

let totalIssues = 0;
for (const [domain, transform] of Object.entries(DOMAINS)) {
  const rawPath = path.join(DIR, `${domain}.raw.json`);
  const ktPath = path.join(DIR, `${domain}.swift.json`);
  if (!fs.existsSync(rawPath) || !fs.existsSync(ktPath)) {
    console.log(`— ${domain}: no capture (run 'swift run ParityDump' in the repo root first)`);
    continue;
  }
  const raw = JSON.parse(fs.readFileSync(rawPath, 'utf8'));
  const kt = JSON.parse(fs.readFileSync(ktPath, 'utf8'));
  let js: any;
  try {
    js = transform(raw);
  } catch (e: any) {
    console.log(`✗ ${domain}: JS transform threw — ${e.message}`);
    totalIssues++;
    continue;
  }

  const jsArr = Array.isArray(js) ? js : [js];
  const ktArr = Array.isArray(kt) ? kt : [kt];
  if (jsArr.length !== ktArr.length) {
    console.log(`✗ ${domain}: item count differs — js ${jsArr.length}, swift ${ktArr.length}`);
    totalIssues++;
  }

  // aggregate per-key so one bad field doesn't print 40 times
  const byKey = new Map<string, { kind: string; count: number; sample: Diff }>();
  const n = Math.min(jsArr.length, ktArr.length);
  for (let i = 0; i < n; i++) {
    for (const d of diffObject(jsArr[i], ktArr[i])) {
      const cur = byKey.get(d.key);
      if (cur) cur.count++;
      else byKey.set(d.key, { kind: d.kind, count: 1, sample: d });
    }
  }

  if (byKey.size === 0) {
    console.log(`✓ ${domain}: ${n} item(s), all fields match`);
    continue;
  }
  console.log(`✗ ${domain}: ${byKey.size} field(s) differ across ${n} item(s)`);
  for (const [key, info] of [...byKey.entries()].sort()) {
    const tag = info.kind === 'missing' ? 'MISSING in swift' : info.kind === 'extra' ? 'extra in swift' : 'value differs';
    console.log(`   ${key} — ${tag} (${info.count}×)`);
    console.log(`      js: ${short(info.sample.js)}`);
    console.log(`   swift: ${short(info.sample.swift)}`);
    totalIssues++;
  }
}

console.log(totalIssues === 0 ? '\nPARITY OK — every captured field matches the JS SDK.' : `\n${totalIssues} parity issue(s) to review.`);
