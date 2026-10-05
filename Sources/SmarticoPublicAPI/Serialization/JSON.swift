import Foundation

/**
 * A JSON value — the Swift form of kotlinx's `JsonElement`.
 *
 * The wire protocol is schemaless JSON: requests are built as objects, every
 * frame is parsed into one before anything typed sees it, and fields the TS
 * declarations leave as `any` stay raw. Numbers are `Double` because the wire
 * format has a single numeric type; every id seen on the wire fits in 2^53, so
 * nothing is lost (`int64`/`int` read them back exactly).
 *
 * The accessors mirror the kotlinx ones the Kotlin SDK uses:
 * `string` ≈ `jsonPrimitive.contentOrNull` (the text of any primitive),
 * `int64`/`int`/`double` ≈ `longOrNull`/`intOrNull`/`doubleOrNull`,
 * `bool` ≈ `booleanOrNull`, `object`/`array` ≈ `as? JsonObject`/`as? JsonArray`.
 */
public enum JSON: Hashable, Sendable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array([JSON])
    case object([String: JSON])
}

/** `JsonObject` from kotlinx: the shape of every request payload and response frame. */
public typealias JSONObject = [String: JSON]

// MARK: - Accessors

extension JSON {
    /** The value under `key` when this is an object; `nil` otherwise. */
    public subscript(key: String) -> JSON? {
        if case .object(let o) = self { return o[key] }
        return nil
    }

    /** The element at `index` when this is an array and the index is in range. */
    public subscript(index: Int) -> JSON? {
        if case .array(let a) = self, a.indices.contains(index) { return a[index] }
        return nil
    }

    public var isNull: Bool {
        if case .null = self { return true }
        return false
    }

    /**
     * The text of any primitive (kotlinx `contentOrNull`): a string as is, a
     * number in its shortest form (`5`, not `5.0`), a bool as `true`/`false`.
     * `nil` for null, arrays and objects.
     */
    public var string: String? {
        switch self {
        case .string(let s): return s
        case .number(let d): return JSON.numberText(d)
        case .bool(let b): return b ? "true" : "false"
        default: return nil
        }
    }

    /** A number, or a string holding one. */
    public var double: Double? {
        switch self {
        case .number(let d): return d
        case .string(let s): return Double(s.trimmingCharacters(in: .whitespaces))
        default: return nil
        }
    }

    /** An integral number (or a string holding one) that fits in `Int64`; `nil` for `5.5`. */
    public var int64: Int64? {
        switch self {
        case .number(let d): return Int64(exactly: d)
        case .string(let s):
            let t = s.trimmingCharacters(in: .whitespaces)
            if let v = Int64(t) { return v }
            return Double(t).flatMap { Int64(exactly: $0) }
        default: return nil
        }
    }

    /** Same as `int64`, narrowed to `Int`. */
    public var int: Int? {
        int64.flatMap { Int(exactly: $0) }
    }

    /** A bool, or the strings `"true"`/`"false"` (kotlinx `booleanOrNull`). Numbers are not bools here. */
    public var bool: Bool? {
        switch self {
        case .bool(let b): return b
        case .string("true"): return true
        case .string("false"): return false
        default: return nil
        }
    }

    public var array: [JSON]? {
        if case .array(let a) = self { return a }
        return nil
    }

    public var object: JSONObject? {
        if case .object(let o) = self { return o }
        return nil
    }
}

// MARK: - Foundation bridging

extension JSON {
    /**
     * Wrap a Foundation/`JSONSerialization` value (or a plain Swift one):
     * `NSNull`/`nil` → `.null`, `NSNumber` booleans → `.bool`, other numbers →
     * `.number`, `[Any]`/`[String: Any]` recursively. `WKScriptMessage.body`
     * arrives in exactly this form. Anything else becomes its text.
     */
    public init(any value: Any?) {
        guard let value = value else { self = .null; return }
        switch value {
        case let j as JSON:
            self = j
        case is NSNull:
            self = .null
        case let s as String:
            self = .string(s)
        case let n as NSNumber:
            // Swift Bool bridges to the CFBoolean singletons; any other number
            // (Int, Double, a JSONSerialization 1) is a CFNumber.
            if CFGetTypeID(n) == CFBooleanGetTypeID() {
                self = .bool(n.boolValue)
            } else {
                self = .number(n.doubleValue)
            }
        case let a as [Any?]:
            self = .array(a.map { JSON(any: $0) })
        case let o as [String: Any?]:
            self = .object(o.mapValues { JSON(any: $0) })
        default:
            self = .string(String(describing: value))
        }
    }

    /**
     * The Foundation form (`NSNull`, `Bool`, `Int`/`Double`, `String`, `[Any]`,
     * `[String: Any]`) — what `JSONSerialization` and `WKWebView` accept.
     * Integral numbers come back as `Int` so they print without a fraction.
     */
    public var anyValue: Any {
        switch self {
        case .null: return NSNull()
        case .bool(let b): return b
        case .number(let d):
            if let i = JSON.exactInteger(d), let n = Int(exactly: i) { return n }
            return d
        case .string(let s): return s
        case .array(let a): return a.map { $0.anyValue }
        case .object(let o): return o.mapValues { $0.anyValue }
        }
    }
}

// MARK: - Text

/** Thrown by `JSON.parse` for input that is not JSON. */
public struct JSONParseError: Error, CustomStringConvertible {
    public let description: String
}

extension JSON {
    /** Parse a UTF-8 JSON document (any top-level value, not only objects). */
    public static func parse(_ data: Data) throws -> JSON {
        do {
            let any = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
            return JSON(any: any)
        } catch {
            throw JSONParseError(description: "invalid JSON: \(error.localizedDescription)")
        }
    }

    /** Parse a JSON document held in a string. */
    public static func parse(_ text: String) throws -> JSON {
        try parse(Data(text.utf8))
    }

    /** Compact UTF-8 encoding (see `jsonString`). */
    public func data(sortedKeys: Bool = true) -> Data {
        Data(jsonString(sortedKeys: sortedKeys).utf8)
    }

    /**
     * Compact JSON text. Integral numbers print without a fraction (`5`, not
     * `5.0`), `/` and non-ASCII are left unescaped (as kotlinx does), and keys
     * are sorted by default so the output is deterministic — Swift
     * dictionaries have no insertion order to preserve.
     */
    public func jsonString(sortedKeys: Bool = true) -> String {
        var out = ""
        write(into: &out, sortedKeys: sortedKeys)
        return out
    }

    private func write(into out: inout String, sortedKeys: Bool) {
        switch self {
        case .null: out += "null"
        case .bool(let b): out += b ? "true" : "false"
        case .number(let d): out += d.isFinite ? JSON.numberText(d) : "null"
        case .string(let s): JSON.writeString(s, into: &out)
        case .array(let a):
            out += "["
            for (i, v) in a.enumerated() {
                if i > 0 { out += "," }
                v.write(into: &out, sortedKeys: sortedKeys)
            }
            out += "]"
        case .object(let o):
            out += "{"
            let keys = sortedKeys ? o.keys.sorted() : Array(o.keys)
            for (i, k) in keys.enumerated() {
                if i > 0 { out += "," }
                JSON.writeString(k, into: &out)
                out += ":"
                o[k]!.write(into: &out, sortedKeys: sortedKeys)
            }
            out += "}"
        }
    }

    private static func writeString(_ s: String, into out: inout String) {
        out += "\""
        for u in s.unicodeScalars {
            switch u {
            case "\"": out += "\\\""
            case "\\": out += "\\\\"
            case "\n": out += "\\n"
            case "\r": out += "\\r"
            case "\t": out += "\\t"
            case "\u{08}": out += "\\b"
            case "\u{0C}": out += "\\f"
            default:
                if u.value < 0x20 {
                    let hex = String(u.value, radix: 16)
                    out += "\\u" + String(repeating: "0", count: 4 - hex.count) + hex
                } else {
                    out.unicodeScalars.append(u)
                }
            }
        }
        out += "\""
    }

    /** `d` as an `Int64` when it is integral and within the exactly-representable range. */
    static func exactInteger(_ d: Double) -> Int64? {
        guard d.isFinite, d.rounded(.towardZero) == d, abs(d) <= 9_007_199_254_740_992 else { return nil }
        return Int64(d)
    }

    /** Shortest text for a number: `5` for 5.0, `1.5`, `1e+300`. */
    static func numberText(_ d: Double) -> String {
        if let i = exactInteger(d) { return String(i) }
        return "\(d)"
    }
}

extension JSON: CustomStringConvertible {
    public var description: String { jsonString() }
}

// MARK: - Codable

extension JSON: Codable {
    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() {
            self = .null
        } else if let b = try? c.decode(Bool.self) {
            self = .bool(b)
        } else if let d = try? c.decode(Double.self) {
            self = .number(d)
        } else if let s = try? c.decode(String.self) {
            self = .string(s)
        } else if let o = try? c.decode([String: JSON].self) {
            self = .object(o)
        } else if let a = try? c.decode([JSON].self) {
            self = .array(a)
        } else {
            throw DecodingError.dataCorruptedError(in: c, debugDescription: "not a JSON value")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .null: try c.encodeNil()
        case .bool(let b): try c.encode(b)
        case .number(let d):
            if let i = JSON.exactInteger(d) { try c.encode(i) } else { try c.encode(d) }
        case .string(let s): try c.encode(s)
        case .array(let a): try c.encode(a)
        case .object(let o): try c.encode(o)
        }
    }
}

// MARK: - Literals

// Request payloads are built inline (`["ach_id": 42, "names": ["a"]]`) the
// way Kotlin builds them with `buildJsonObject { put(…) }`.

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) { self = .null }
}

extension JSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) { self = .bool(value) }
}

extension JSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) { self = .number(Double(value)) }
}

extension JSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) { self = .number(value) }
}

extension JSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
}

extension JSON: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSON...) { self = .array(elements) }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSON)...) {
        var o = JSONObject(minimumCapacity: elements.count)
        for (k, v) in elements { o[k] = v }
        self = .object(o)
    }
}

// MARK: - Typed constructors

extension JSON {
    public init(_ value: String) { self = .string(value) }
    public init(_ value: Bool) { self = .bool(value) }
    public init(_ value: Double) { self = .number(value) }
    public init(_ value: Int) { self = .number(Double(value)) }
    public init(_ value: Int64) { self = .number(Double(value)) }
    public init(_ value: [JSON]) { self = .array(value) }
    public init(_ value: JSONObject) { self = .object(value) }

    /** `.null` for `nil`, otherwise the wrapped value — `JSON(opts.brandKey)` in place of `?: JsonNull`. */
    public init(_ value: String?) { self = value.map { .string($0) } ?? .null }
}
