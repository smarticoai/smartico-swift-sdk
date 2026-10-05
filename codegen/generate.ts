/**
 * Generates Swift structs / enums from the @smartico/public-api type
 * declarations (pinned in package.json — bump it, rerun, review the diff).
 *
 * Reads the published .d.ts (type-only, carries the JSDoc) and writes
 * ../Sources/SmarticoPublicAPI/Types/. Generated files are COMMITTED: the
 * Swift build must never need node.
 */
import { Project, InterfaceDeclaration, EnumDeclaration, TypeAliasDeclaration, Node, PropertySignature } from 'ts-morph';
import * as fs from 'fs';
import * as path from 'path';
import { INTEGRAL_NAME_PATTERNS, FIELD_TYPE_OVERRIDES, SKIP_DECLARATIONS, EXTRA_FIELDS, INLINE_TYPES } from './mappings';

const PKG = path.join(__dirname, 'node_modules', '@smartico', 'public-api');
const VERSION = JSON.parse(fs.readFileSync(path.join(PKG, 'package.json'), 'utf8')).version;
const OUT_DIR = path.join(__dirname, '..', 'Sources', 'SmarticoPublicAPI', 'Types');

const stats = { interfaces: 0, enums: 0, aliases: 0, fields: 0, jsonFallbacks: [] as string[], duplicates: [] as string[] };

/** Reserved Swift keywords that can't be used bare as identifiers. */
const SWIFT_KEYWORDS = new Set([
  'default', 'in', 'is', 'as', 'operator', 'protocol', 'where', 'init', 'self', 'Self', 'Type', 'class', 'struct',
  'enum', 'func', 'var', 'let', 'import', 'return', 'true', 'false', 'nil', 'extension', 'static', 'public',
  'private', 'internal', 'fileprivate', 'case', 'switch', 'if', 'else', 'for', 'while', 'do', 'repeat', 'break',
  'continue', 'throw', 'throws', 'try', 'catch', 'guard', 'defer', 'subscript', 'typealias', 'associatedtype',
  'inout', 'rethrows', 'super', 'Any', 'fallthrough', 'deinit',
]);

const swiftName = (n: string) => (SWIFT_KEYWORDS.has(n) ? `\`${n}\`` : n);

const IDENTIFIER = /^[A-Za-z_][A-Za-z0-9_]*$/;

/** number → Int64 or Double, decided by the field name (see mappings.ts). */
function numberType(fieldName: string): string {
  return INTEGRAL_NAME_PATTERNS.some((re) => re.test(fieldName)) ? 'Int64' : 'Double';
}

/** A Swift string literal (JSON.stringify's `\uXXXX` is not Swift syntax). */
function swiftString(s: string): string {
  let out = '"';
  for (const ch of s) {
    const code = ch.codePointAt(0)!;
    if (ch === '"') out += '\\"';
    else if (ch === '\\') out += '\\\\';
    else if (ch === '\n') out += '\\n';
    else if (ch === '\r') out += '\\r';
    else if (ch === '\t') out += '\\t';
    else if (code < 0x20) out += `\\u{${code.toString(16)}}`;
    else out += ch;
  }
  return out + '"';
}

/**
 * What each exported declaration became, filled by pass 1. Field types are
 * resolved against it in pass 2: an enum reference has to become its underlying
 * wire primitive (our enums are emitted as namespaces of constants, not Swift
 * types), and a name we never generated (or a generic type parameter) can only
 * be JSON.
 */
type DeclKind = 'class' | 'enumInt' | 'enumString' | 'alias';
const registry = new Map<string, DeclKind>();
/** Interface declarations by name, for resolving `extends` chains. */
const interfaces = new Map<string, InterfaceDeclaration>();
/**
 * What each type alias resolves to in Swift, filled before pass 2: a field
 * typed with an alias still needs the lenient helper of the type underneath.
 */
const aliasTargets = new Map<string, string>();
/** Type-parameter names in scope while emitting a generic declaration. */
let typeParams = new Set<string>();

/** Map a TS type node to Swift. `owner.field` drives numeric + override rules. */
function toSwiftType(typeText: string, fieldName: string, owner: string): string {
  const override = FIELD_TYPE_OVERRIDES[`${owner}.${fieldName}`];
  if (override) return override;

  let t = typeText.trim();
  // strip a trailing "| null"/"| undefined" — nullability is handled by the caller
  t = t.replace(/\s*\|\s*(null|undefined)\s*$/g, '').trim();

  // arrays: T[] and Array<T>
  const arr = t.match(/^(.*)\[\]$/) ?? t.match(/^Array<(.*)>$/);
  if (arr) return `[${toSwiftType(arr[1], fieldName, owner)}]`;

  // maps: Record<string, X> / { [k: string]: X }
  const rec = t.match(/^Record<\s*string\s*,\s*(.*)>$/);
  if (rec) return `[String: ${toSwiftType(rec[1], fieldName, owner)}]`;

  switch (t) {
    case 'string': return 'String';
    case 'boolean': return 'Bool';
    case 'number': return numberType(fieldName);
    case 'any':
    case 'unknown':
    case 'object': return 'JSON';
    case 'void':
    case 'never': return 'JSON';
  }

  // string-literal unions ('a' | 'b') → String; mixed unions → JSON
  if (t.includes('|')) {
    const parts = t.split('|').map((p) => p.trim());
    if (parts.every((p) => /^'.*'$/.test(p) || /^".*"$/.test(p))) return 'String';
    stats.jsonFallbacks.push(`${owner}.${fieldName}: ${t}`);
    return 'JSON';
  }

  // inline object literals → JSON (nested anonymous shapes are rare)
  if (t.startsWith('{')) {
    stats.jsonFallbacks.push(`${owner}.${fieldName}: inline object`);
    return 'JSON';
  }

  // a named type: resolve against what pass 1 actually generated
  const generic = t.match(/^([A-Za-z_][A-Za-z0-9_]*)<(.*)>$/);
  if (generic) {
    // Generic containers we don't model (GResponse<T>, …) degrade to raw JSON.
    stats.jsonFallbacks.push(`${owner}.${fieldName}: ${t}`);
    return 'JSON';
  }
  if (/^[A-Za-z_][A-Za-z0-9_.]*$/.test(t)) {
    const bare = t.split('.').pop()!;
    if (typeParams.has(bare)) return 'JSON'; // an unbound generic parameter
    const kind = registry.get(bare);
    if (kind === 'class') return bare;
    // Enums are namespaces of constants, not types — use the wire primitive they hold.
    if (kind === 'enumInt') return 'Int64';
    if (kind === 'enumString') return 'String';
    if (kind === 'alias') return bare;
    stats.jsonFallbacks.push(`${owner}.${fieldName}: unknown type ${bare}`);
    return 'JSON';
  }

  stats.jsonFallbacks.push(`${owner}.${fieldName}: ${t}`);
  return 'JSON';
}

/**
 * The lenient read of one field inside the generated `init(from:)` — the
 * helper is chosen by the Swift type (see Serialization/Lenient.swift).
 */
function decodeExpr(type: string, key: string, seen = new Set<string>()): string {
  const k = swiftString(key);
  switch (type) {
    case 'Int64': return `try c.lenientInt64(${k})`;
    case 'Double': return `try c.lenientDouble(${k})`;
    case 'Bool': return `try c.lenientBool(${k})`;
    case 'String': return `try c.lenientString(${k})`;
    case 'JSON': return `try c.lenientJSON(${k})`;
  }
  const dict = type.match(/^\[String: (.*)\]$/);
  if (dict) return `try c.lenientDict(${dict[1]}.self, ${k})`;
  const list = type.match(/^\[(.*)\]$/);
  if (list) return `try c.lenientList(${list[1]}.self, ${k})`;
  const target = aliasTargets.get(type);
  if (target !== undefined && !seen.has(type)) {
    seen.add(type);
    return decodeExpr(target, key, seen);
  }
  return `try c.lenientObject(${type}.self, ${k})`;
}

/** JSDoc above a declaration/property → `///` doc comment. */
function docComment(node: Node, indent = ''): string {
  const docs = (node as any).getJsDocs?.() ?? [];
  if (!docs.length) return '';
  return docLines(sanitizeDoc(docs.map((d: any) => d.getInnerText().trim()).join('\n').trim()), indent);
}

function docLines(text: string, indent = ''): string {
  if (!text) return '';
  return text.split('\n').map((l: string) => `${indent}/// ${l}`.trimEnd()).join('\n') + '\n';
}

/**
 * The source docs are written for the web embed: they call the API through the
 * `window._smartico` global and show JavaScript snippets. A Swift consumer has
 * neither, so every reference is retargeted at this SDK's own entry point and
 * lines that only make sense on a web page are dropped.
 */
function sanitizeDoc(text: string): string {
  const WEB_ONLY = /(window\._smartico|tracker bundle|embed snippet|the Smartico embed|on the page|browser page|<script)/i;
  return text
    .split('\n')
    .filter((line) => !WEB_ONLY.test(line))
    .map((line) =>
      line
        .replace(/window\._smartico/g, 'Smartico')
        .replace(/_smartico\.api\./g, 'Smartico.api.')
        .replace(/_smartico\./g, 'Smartico.')
        .replace(/\bJavaScript\b/g, 'client')
        // "…, as in JS `Date.getTimezoneOffset()`" — the rule is the same
        // everywhere, the JS spelling of it is not useful here
        .replace(/,?\s*as in JS `[^`]+`/g, '')
        .replace(/\bJS consumers\b/gi, 'Consumers')
        .replace(/\bJS\b/g, 'client'),
    )
    .join('\n')
    .trim();
}

/** Own properties plus everything inherited via `extends`, base-first. */
function allProperties(decl: InterfaceDeclaration, seen = new Set<string>()): PropertySignature[] {
  const inherited: PropertySignature[] = [];
  for (const ext of decl.getExtends()) {
    const baseName = ext.getText().replace(/<.*>$/, '').split('.').pop()!;
    if (seen.has(baseName)) continue;
    seen.add(baseName);
    const base = interfaces.get(baseName);
    if (base) inherited.push(...allProperties(base, seen));
  }
  const own = decl.getProperties();
  const ownNames = new Set(own.map((p) => p.getName()));
  // a redeclared field wins over the inherited one
  return [...inherited.filter((p) => !ownNames.has(p.getName())), ...own];
}

/** One stored property of a generated struct. */
type Field = { name: string; type: string; doc: string };

/**
 * Structs synthesised from anonymous object literals (see INLINE_TYPES),
 * keyed by Swift type name so the same shape is emitted once.
 */
const synthetic = new Map<string, string>();

/** One field, shared by real interfaces and synthesised literals. */
function fieldOf(p: PropertySignature, owner: string): Field {
  stats.fields++;
  const rawName = p.getName().replace(/^["']|["']$/g, '');
  // The wire name IS the Swift name (that is what keeps the synthesized
  // encode(to:) writing wire keys); a name that can't be one needs CodingKeys.
  if (!IDENTIFIER.test(rawName)) {
    throw new Error(`${owner}.${rawName}: not a Swift identifier — the emitter needs an explicit CodingKeys mapping for it`);
  }
  return { name: rawName, type: fieldType(p, rawName, owner), doc: docComment(p, '    ') };
}

/**
 * The Swift type of one property: a named inline type when mapped, otherwise
 * the regular text-driven resolution.
 */
function fieldType(p: PropertySignature, rawName: string, owner: string): string {
  const mapped = INLINE_TYPES[`${owner}.${rawName}`];
  const node = p.getTypeNode();
  if (mapped && node) {
    const built = synthesiseLiteral(node, mapped);
    if (built) return built;
  }
  return toSwiftType(node?.getText() ?? 'any', rawName, owner);
}

/**
 * Emit a struct for an anonymous object literal and return the Swift type
 * referencing it (`Name` or `[Name]`). Returns null when the node isn't a
 * literal after unwrapping `| null` / `| undefined` and array brackets.
 */
function synthesiseLiteral(node: Node, name: string): string | null {
  let target: Node = node;
  if (Node.isUnionTypeNode(target)) {
    const real = target.getTypeNodes().find((n) => !/^(null|undefined)$/.test(n.getText().trim()));
    if (!real) return null;
    target = real;
  }
  if (Node.isParenthesizedTypeNode(target)) target = target.getTypeNode();
  let list = false;
  if (Node.isArrayTypeNode(target)) {
    list = true;
    target = target.getElementTypeNode();
  }
  if (Node.isUnionTypeNode(target)) {
    const real = target.getTypeNodes().find((n) => !/^(null|undefined)$/.test(n.getText().trim()));
    if (!real) return null;
    target = real;
  }
  if (!Node.isTypeLiteral(target)) return null;

  if (!synthetic.has(name)) {
    synthetic.set(name, ''); // reserve the name first: a literal may nest itself
    const members = target.getMembers().filter(Node.isPropertySignature) as PropertySignature[];
    const fields = members.map((m) => fieldOf(m, name));
    synthetic.set(
      name,
      emitStruct(
        name,
        docLines(
          `${name} — generated from the anonymous object literal the public API\n` +
            `declares inline; the fields are exactly the ones declared there.`,
        ),
        fields,
      ),
    );
  }
  return list ? `[${name}]` : name;
}

/**
 * The struct shape every interface becomes: optional `public var` fields, a
 * memberwise init defaulting everything to nil (what hand-written transforms
 * build with), and a lenient `init(from:)`. `encode(to:)` and `CodingKeys`
 * stay synthesized — property names are the wire names, so the encoder writes
 * exactly what the server sent.
 */
function emitStruct(name: string, doc: string, fields: Field[], trailer = ''): string {
  // A keyword field keeps its name as the argument label but gets a plain
  // internal parameter name: a parameter literally named `self` would shadow
  // `self` inside the init.
  const param = (f: Field) => (SWIFT_KEYWORDS.has(f.name) ? `${swiftName(f.name)} _${f.name}` : f.name);
  const arg = (f: Field) => (SWIFT_KEYWORDS.has(f.name) ? `_${f.name}` : f.name);
  const props = fields.map((f) => `${f.doc}    public var ${swiftName(f.name)}: ${f.type}?`).join('\n');
  const params = fields.map((f) => `        ${param(f)}: ${f.type}? = nil`).join(',\n');
  const assigns = fields.map((f) => `        self.${swiftName(f.name)} = ${arg(f)}`).join('\n');
  const reads = fields.map((f) => `        self.${swiftName(f.name)} = ${decodeExpr(f.type, f.name)}`).join('\n');
  return (
    `${doc}public struct ${name}: Codable, Hashable, Sendable {\n` +
    `${props}\n\n` +
    `    public init(\n${params}\n    ) {\n${assigns}\n    }\n\n` +
    `    public init(from decoder: Decoder) throws {\n` +
    `        let c = try decoder.container(keyedBy: AnyCodingKey.self)\n` +
    `${reads}\n` +
    `    }\n` +
    `}\n${trailer}`
  );
}

function emitInterface(decl: InterfaceDeclaration): string {
  const name = decl.getName();
  const props = allProperties(decl);
  stats.interfaces++;
  typeParams = new Set(decl.getTypeParameters().map((tp) => tp.getName()));

  // Every field is optional with a nil default: the server omits fields freely
  // and a strict parser would otherwise throw on a payload we don't fully model.
  const fields = props.map((p: PropertySignature) => fieldOf(p, name));

  for (const [name2, extra] of Object.entries(EXTRA_FIELDS)) {
    if (name2 !== name) continue;
    for (const [field, sType] of Object.entries(extra)) {
      if (props.some((p) => p.getName().replace(/["']/g, '') === field)) continue;
      stats.fields++;
      fields.push({
        name: field,
        type: sType,
        doc: '    /// Sent by the server but absent from the TS declaration (parity fix).\n',
      });
    }
  }

  const extendsList = decl.getExtends().map((e) => e.getText());
  const inherited = extendsList.length
    ? `// Inherited fields from ${extendsList.join(', ')} are flattened above.\n`
    : '';

  // Interfaces with no properties (marker/extends-only) become a struct with
  // a single raw placeholder, as the Kotlin data class does.
  const body = fields.length ? fields : [{ name: 'placeholder', type: 'JSON', doc: '' }];
  return emitStruct(name, docComment(decl), body, inherited);
}

function emitEnum(decl: EnumDeclaration): string {
  const name = decl.getName();
  stats.enums++;
  // ClassId constants are the `cid` values the transport takes as Int;
  // every other numeric protocol enum is an Int64 wire value.
  const intType = name === 'ClassId' ? 'Int' : 'Int64';
  const members = decl.getMembers().map((m) => {
    const value = m.getValue();
    const wireName = m.getName().replace(/^["']|["']$/g, '');
    // Wire names aren't always valid Swift identifiers ('2x', '/2', …):
    // sanitize, and keep the original in a doc comment so the mapping stays obvious.
    const safe = IDENTIFIER.test(wireName) ? wireName : '_' + wireName.replace(/[^A-Za-z0-9_]/g, '');
    const doc = safe === wireName ? '' : `    /// wire name: ${swiftString(wireName)}\n`;
    if (typeof value === 'string') return `${doc}    public static let ${swiftName(safe)}: String = ${swiftString(value)}`;
    const n = value ?? 0;
    const type = Number.isInteger(n) ? intType : 'Double';
    return `${doc}    public static let ${swiftName(safe)}: ${type} = ${n}`;
  });
  // Protocol enums are plain wire constants — a caseless enum of static lets
  // keeps them usable as raw Int64/String values without Codable plumbing.
  return `${docComment(decl)}public enum ${name} {\n${members.join('\n')}\n}\n`;
}

/** Resolve an alias to its Swift type once, before any field references it. */
function resolveAlias(decl: TypeAliasDeclaration): string {
  const name = decl.getName();
  typeParams = new Set(decl.getTypeParameters().map((tp) => tp.getName()));
  let t = toSwiftType(decl.getTypeNode()?.getText() ?? 'any', name, name);
  if (t === name) t = 'JSON'; // an alias can't reference itself
  return t;
}

function emitAlias(decl: TypeAliasDeclaration): string {
  const name = decl.getName();
  stats.aliases++;
  return `${docComment(decl)}public typealias ${name} = ${aliasTargets.get(name)}\n`;
}

function main() {
  const project = new Project({ compilerOptions: { allowJs: false } });
  // SmarticoLib/ is a legacy bundled copy: 104 declarations, 88 of them stale
  // duplicates of the canonical ones (its TLevel is missing ordinal_position).
  // Generating from it silently produced wrong classes — exclude it.
  project.addSourceFilesAtPaths([
    path.join(PKG, 'dist', '**', '*.d.ts'),
    '!' + path.join(PKG, 'dist', 'SmarticoLib', '**'),
  ]);

  fs.rmSync(OUT_DIR, { recursive: true, force: true });
  fs.mkdirSync(OUT_DIR, { recursive: true });

  const header = (_name: string) =>
    `// GENERATED from @smartico/public-api ${VERSION} — DO NOT EDIT.\n` +
    `// Regenerate: cd codegen && npm run gen\n\n` +
    // The server speaks JS numbers: any numeric field can arrive as 5, 5.0 or
    // 1.3e8. The lenient helpers every init(from:) reads through absorb that
    // (see Serialization/Lenient.swift).
    `import Foundation\n\n`;

  // Pass 1: record what every exported declaration will become, so pass 2 can
  // resolve field types that reference other declarations.
  const seen = new Set<string>();
  const todo: Node[] = [];
  for (const sf of project.getSourceFiles()) {
    for (const decl of [...sf.getInterfaces(), ...sf.getEnums(), ...sf.getTypeAliases()]) {
      const name = decl.getName();
      if (!decl.isExported() || SKIP_DECLARATIONS.has(name)) continue;
      if (seen.has(name)) {
        // Two declarations of one name = we'd silently generate from whichever
        // file was scanned first. Surface it; don't guess.
        stats.duplicates.push(`${name} (also in ${path.relative(PKG, sf.getFilePath())})`);
        continue;
      }
      seen.add(name);
      todo.push(decl);
      if (Node.isEnumDeclaration(decl)) {
        const stringy = decl.getMembers().some((m) => typeof m.getValue() === 'string');
        registry.set(name, stringy ? 'enumString' : 'enumInt');
      } else if (Node.isInterfaceDeclaration(decl)) {
        registry.set(name, 'class');
        interfaces.set(name, decl);
      } else {
        registry.set(name, 'alias');
      }
    }
  }

  // Aliases resolve before any struct is emitted: a field typed with one needs
  // the lenient helper of the type underneath.
  for (const decl of todo) {
    if (Node.isTypeAliasDeclaration(decl)) aliasTargets.set(decl.getName(), resolveAlias(decl));
  }

  // Pass 2: emit.
  {
    for (const decl of todo as any[]) {
      const name = decl.getName();
      const body = Node.isInterfaceDeclaration(decl)
        ? emitInterface(decl)
        : Node.isEnumDeclaration(decl)
          ? emitEnum(decl)
          : emitAlias(decl as TypeAliasDeclaration);
      fs.writeFileSync(path.join(OUT_DIR, `${name}.swift`), header(name) + body);
    }
    // Types synthesised from inline literals (INLINE_TYPES) — emitted last,
    // once every referencing interface has been walked.
    for (const [name, body] of synthetic) {
      fs.writeFileSync(path.join(OUT_DIR, `${name}.swift`), header(name) + body);
    }
  }

  const files = fs.readdirSync(OUT_DIR).filter((f) => f.endsWith('.swift')).length;
  console.log(`generated from public-api ${VERSION} → ${path.relative(process.cwd(), OUT_DIR)} (${files} files)`);
  console.log(`  structs      : ${stats.interfaces}`);
  console.log(`  enums        : ${stats.enums}`);
  console.log(`  typealiases  : ${stats.aliases}`);
  console.log(`  fields       : ${stats.fields}`);
  console.log(`  inline types : ${synthetic.size} (${[...synthetic.keys()].join(', ')})`);
  if (stats.duplicates.length) {
    console.log(`  DUPLICATE declarations skipped: ${stats.duplicates.length}`);
    for (const d of stats.duplicates) console.log(`    ! ${d}`);
  }
  console.log(`  JSON fallbacks: ${stats.jsonFallbacks.length}`);
  for (const f of stats.jsonFallbacks.slice(0, 15)) console.log(`    - ${f}`);
  if (stats.jsonFallbacks.length > 15) console.log(`    … ${stats.jsonFallbacks.length - 15} more`);
}

main();
