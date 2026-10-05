/**
 * Signature parity: compares every WSAPI method's name, parameters and return
 * type against our Swift declaration. Field parity (parity.ts) proves the DATA
 * matches; this proves the CALL SHAPE matches, so code written against the JS
 * SDK's docs translates 1:1.
 */
import { Project, MethodDeclaration } from 'ts-morph';
import * as fs from 'fs';
import * as path from 'path';

const PKG = path.join(__dirname, 'node_modules', '@smartico', 'public-api');
const SWIFT_DIR = path.join(__dirname, '..', 'Sources', 'SmarticoPublicAPI', 'Api');

type JsMethod = { name: string; params: { name: string; optional: boolean; type: string }[]; returns: string };
type SwiftMethod = { name: string; params: { name: string; optional: boolean; type: string }[]; returns: string };

// ---- JS side -----------------------------------------------------------------
const project = new Project();
project.addSourceFilesAtPaths(path.join(PKG, 'dist', 'WSAPI', '*.d.ts'));
const js = new Map<string, JsMethod>();
for (const sf of project.getSourceFiles()) {
  for (const cls of sf.getClasses()) {
    for (const m of cls.getMethods() as MethodDeclaration[]) {
      const name = m.getName();
      if (name.startsWith('_') || js.has(name)) continue;
      js.set(name, {
        name,
        params: m.getParameters().flatMap((p) => {
          const type = p.getTypeNode()?.getText() ?? 'any';
          const optional = p.isOptional() || p.hasInitializer();
          // `props: { a: number; b: number }` in JS == named args a, b in Swift
          const inline = type.trim().match(/^\{(.*)\}$/s);
          if (inline) {
            // strip JSDoc from inside the object literal before splitting fields
            return inline[1]
              .replace(/\/\*\*[\s\S]*?\*\//g, '')
              .split(';')
              .map((f) => f.trim())
              .filter(Boolean)
              .map((f) => {
                const [fname, ftype] = f.split(':').map((x) => x.trim());
                return { name: fname.replace(/\?$/, ''), optional: optional || fname.endsWith('?'), type: ftype ?? 'any' };
              });
          }
          return [{ name: p.getName().replace(/^\{|\}$/g, '').trim(), optional, type }];
        }),
        returns: (m.getReturnTypeNode()?.getText() ?? 'unknown').replace(/^Promise<(.*)>$/s, '$1'),
      });
    }
  }
}

// ---- Swift side --------------------------------------------------------------
/** Split on commas that are not nested inside (), [] or <>. */
function splitTopLevel(text: string): string[] {
  const parts: string[] = [];
  let buf = '', d = 0;
  for (const ch of text) {
    if (ch === '(' || ch === '<' || ch === '[') d++;
    else if (ch === ')' || ch === '>' || ch === ']') d--;
    if (ch === ',' && d === 0) { parts.push(buf); buf = ''; continue; }
    buf += ch;
  }
  if (buf.trim()) parts.push(buf);
  return parts;
}

const sw = new Map<string, SwiftMethod>();
const files = fs.existsSync(SWIFT_DIR) ? fs.readdirSync(SWIFT_DIR).filter((f) => f.endsWith('.swift')) : [];
for (const f of files) {
  const src = fs.readFileSync(path.join(SWIFT_DIR, f), 'utf8');
  const re = /public func ([A-Za-z0-9_]+)\s*\(/g;
  for (const m of src.matchAll(re)) {
    const name = m[1];
    // walk to the matching ")" — default values contain parens of their own
    let i = m.index! + m[0].length, depth = 1;
    while (i < src.length && depth > 0) {
      if (src[i] === '(') depth++;
      else if (src[i] === ')') depth--;
      i++;
    }
    const rawParams = src.slice(m.index! + m[0].length, i - 1);
    // `async throws -> T {` — no arrow means Void
    const tail = src.slice(i).match(/^\s*(?:async\s+)?(?:throws\s+)?(?:->\s*([^{]+?))?\s*\{/);
    const returns = tail && tail[1] ? tail[1].trim() : 'Void';
    const params = splitTopLevel(rawParams)
      .map((p) => p.trim())
      .filter(Boolean)
      .map((p) => {
        const [decl, ...def] = p.split('=');
        // the first ":" separates the name from the type ([String: JSON] has its own)
        const colon = decl.indexOf(':');
        const names = decl.slice(0, colon).trim().split(/\s+/);
        const ptype = decl.slice(colon + 1).trim();
        // `label name: T` is called as `label:`; `_ name: T` positionally, so compare `name`
        const pname = (names[0] === '_' ? names[names.length - 1] : names[0]).replace(/`/g, '');
        return { name: pname, optional: def.length > 0 || ptype.endsWith('?'), type: ptype };
      });
    sw.set(name, { name, params, returns: returns.trim() });
  }
}

// ---- compare -----------------------------------------------------------------
/** JS uses snake_case params, Swift camelCase — compare on a normalized form. */
const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9]/g, '');
/** `[T]` is a list; `[String: T]` is a map. */
const isSwiftList = (s: string) => /^\[.*\]$/.test(s) && !/^\[\s*String\s*:/.test(s);
/** Does the Swift return type plausibly express the JS one? */
function returnsMatch(jsRet: string, swRet: string): boolean {
  // strip TS import() qualifiers and Swift optionality before comparing
  const strip = (s: string) => s.trim().replace(/^import\(".*?"\)\./, '').replace(/\?$/, '');
  const js = strip(jsRet), swift = strip(swRet);
  const jsList = /\[\]$/.test(js) || /^Array</.test(js);
  const swList = isSwiftList(swift);
  if (jsList !== swList) return false;
  const jsCore = js.replace(/\[\]$/, '').replace(/^Array<(.*)>$/, '$1');
  const swCore = swList ? swift.replace(/^\[(.*)\]$/, '$1') : swift;
  // TS `number` has no width; Swift must pick one
  const NUMERIC = new Set(['number', 'long', 'int', 'int64', 'double', 'float']);
  if (NUMERIC.has(norm(jsCore)) && NUMERIC.has(norm(swCore))) return true;
  // TS `void` is Swift's Void
  const VOID = new Set(['void', 'unit', 'undefined', '']);
  if (VOID.has(norm(jsCore)) && VOID.has(norm(swCore))) return true;
  // TS `boolean` is Swift's Bool
  const BOOL = new Set(['boolean', 'bool']);
  if (BOOL.has(norm(jsCore)) && BOOL.has(norm(swCore))) return true;
  return norm(jsCore) === norm(swCore);
}

/**
 * WSAPI's reactive cache layer: the 30s OCache, onUpdate callbacks and the
 * update/clear/notify helpers. Deliberately NOT ported — the cache is never invalidated by
 * server pushes, so it silently serves stale data — this SDK always hits the
 * socket and lets the host decide when to refresh.
 */
const CACHE_LAYER = /^(update|clear|notify|reload)|ClearCache$/;

let issues = 0;
const missing: string[] = [];
const skipped: string[] = [];
for (const [name, j] of [...js].sort()) {
  const k = sw.get(name);
  if (!k) {
    (CACHE_LAYER.test(name) ? skipped : missing).push(name);
    continue;
  }
  const notes: string[] = [];

  // required params must line up 1:1; optional ones may be defaulted differently
  const jsReq = j.params.filter((p) => !p.optional);
  const swReq = k.params.filter((p) => !p.optional);
  if (jsReq.length !== swReq.length) {
    notes.push(`required params: js(${jsReq.map((p) => p.name).join(', ') || '—'}) vs swift(${swReq.map((p) => p.name).join(', ') || '—'})`);
  } else {
    for (let i = 0; i < jsReq.length; i++) {
      if (norm(jsReq[i].name) !== norm(swReq[i].name)) {
        notes.push(`param #${i + 1} name: js '${jsReq[i].name}' vs swift '${swReq[i].name}'`);
      }
    }
  }
  // onUpdate is part of the cache layer we don't port (see CACHE_LAYER)
  const jsParams = j.params.filter((p) => p.name !== 'onUpdate');
  if (jsParams.length !== k.params.length) {
    notes.push(`param count: js ${jsParams.length} vs swift ${k.params.length} (js: ${jsParams.map((p) => p.name + (p.optional ? '?' : '')).join(', ')} | swift: ${k.params.map((p) => p.name + (p.optional ? '?' : '')).join(', ')})`);
  }
  if (!returnsMatch(j.returns, k.returns)) {
    notes.push(`returns: js '${j.returns}' vs swift '${k.returns}'`);
  }

  if (notes.length) {
    console.log(`✗ ${name}`);
    for (const n of notes) console.log(`   ${n}`);
    issues += notes.length;
  }
}

console.log(`\nimplemented: ${js.size - missing.length - skipped.length}/${js.size - skipped.length} (excluding ${skipped.length} cache-layer helpers)`);
console.log(`signature issues: ${issues}`);
if (missing.length) console.log(`not implemented yet (${missing.length}): ${missing.join(', ')}`);
