import Foundation

/**
 * Wire-tolerant decoding — the Swift form of `LenientNumbers.kt`.
 *
 * The wire format has a single numeric type, a double: the SAME field
 * can arrive as `5`, `5.0` or (for a big id) `1.37861765E8`, and a string
 * occasionally shows up where a number is documented. The generated types pick
 * Int64/Double/Bool for ergonomics, so parsing must absorb that difference
 * instead of throwing — every generated `init(from:)` reads its fields through
 * these helpers (the Kotlin side applies its serializers file-wide with
 * `@file:UseSerializers`).
 *
 * Rules, identical to the Kotlin serializers plus kotlinx's `isLenient`,
 * `ignoreUnknownKeys` and `explicitNulls = false`:
 *  - a missing key or an explicit `null` is `nil`, never an error;
 *  - integral fields take `5`, `5.0`, `1.37861765E8` and `"5"`; a fraction is
 *    truncated toward zero (`toDouble().toLong()`), anything else present is 0;
 *  - floating fields take numbers and numeric text, anything else present is 0;
 *  - booleans are true for `true`, `1`, `1.0`, `"true"`, `"1"`, `"1.0"`
 *    (case-insensitive) and false for every other present value;
 *  - a number or bool arriving for a `String` field becomes its text;
 *  - unknown keys are ignored (decoding only ever asks for declared keys);
 *  - nested objects, lists and maps are decoded with the same rules, element
 *    by element. A structural mismatch (an object where a list is declared, an
 *    object where a string is declared) throws, as it does in Kotlin.
 */
public struct AnyCodingKey: CodingKey, Hashable, Sendable {
    public var stringValue: String
    public var intValue: Int?

    public init(_ string: String) {
        stringValue = string
        intValue = nil
    }

    public init?(stringValue: String) {
        self.init(stringValue)
    }

    public init?(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

// MARK: - Scalar conversions (shared by fields and collection elements)

enum Lenient {
    /** `LenientLongSerializer`: `toLongOrNull() ?: toDoubleOrNull()?.toLong() ?: 0`. */
    static func int64(_ j: JSON) -> Int64 {
        switch j {
        case .number(let d): return truncate(d)
        case .string(let s):
            let t = s.trimmingCharacters(in: .whitespaces)
            if let v = Int64(t) { return v }
            if let d = Double(t) { return truncate(d) }
            return 0
        default: return 0
        }
    }

    /** `LenientDoubleSerializer`: `toDoubleOrNull() ?: 0.0`. */
    static func double(_ j: JSON) -> Double {
        switch j {
        case .number(let d): return d
        case .string(let s): return Double(s.trimmingCharacters(in: .whitespaces)) ?? 0
        default: return 0
        }
    }

    /** `LenientBooleanSerializer`: `"true"`, `"1"`, `"1.0"` (any case) are true, everything else false. */
    static func bool(_ j: JSON) -> Bool {
        switch j {
        case .bool(let b): return b
        case .number(let d): return d == 1
        case .string(let s):
            switch s.lowercased() {
            case "true", "1", "1.0": return true
            default: return false
            }
        default: return false
        }
    }

    /** kotlinx `isLenient`: an unquoted primitive is read as its text. */
    static func string(_ j: JSON, codingPath: [CodingKey]) throws -> String {
        switch j {
        case .string(let s): return s
        case .number, .bool: return j.string!
        case .null:
            throw DecodingError.valueNotFound(String.self, .init(codingPath: codingPath, debugDescription: "null where a string is expected"))
        case .array, .object:
            throw DecodingError.typeMismatch(String.self, .init(codingPath: codingPath, debugDescription: "expected a string, found \(j.jsonString())"))
        }
    }

    /** Kotlin's `Double.toLong()`: toward zero, saturating, NaN → 0. Swift's `Int64(_:)` would trap instead. */
    static func truncate(_ d: Double) -> Int64 {
        if d.isNaN { return 0 }
        // Double(Int64.max) is 2^63, one past the range — hence `>=`.
        if d >= Double(Int64.max) { return .max }
        if d <= Double(Int64.min) { return .min }
        return Int64(d.rounded(.towardZero))
    }

    /**
     * Element conversion for lists and maps. Kotlin's file-wide serializers
     * reach type arguments too (`List<Long>` elements are lenient), and a
     * `null` element of a numeric list reads as 0 there — kept.
     */
    static func element<T: Decodable>(_ j: JSON, as type: T.Type, codingPath: [CodingKey]) throws -> T? {
        if T.self == Int64.self { return int64(j) as? T }
        if T.self == Double.self { return double(j) as? T }
        if T.self == Bool.self { return bool(j) as? T }
        if T.self == String.self { return try string(j, codingPath: codingPath) as? T }
        return nil
    }

    static func isScalar<T>(_ type: T.Type) -> Bool {
        T.self == Int64.self || T.self == Double.self || T.self == Bool.self || T.self == String.self
    }
}

// MARK: - Field helpers used by every generated init(from:)

extension KeyedDecodingContainer where Key == AnyCodingKey {
    /** `nil` when the key is absent or `null`, otherwise the key to read. */
    @inline(__always)
    private func present(_ key: String) throws -> AnyCodingKey? {
        let k = AnyCodingKey(key)
        guard contains(k), try !decodeNil(forKey: k) else { return nil }
        return k
    }

    public func lenientInt64(_ key: String) throws -> Int64? {
        guard let k = try present(key) else { return nil }
        // The common case (an integer, or 5.0 / 1.37861765E8, which JSONDecoder
        // accepts for an integer when it is exact) needs no fallback.
        if let v = try? decode(Int64.self, forKey: k) { return v }
        return Lenient.int64(try decode(JSON.self, forKey: k))
    }

    public func lenientDouble(_ key: String) throws -> Double? {
        guard let k = try present(key) else { return nil }
        if let v = try? decode(Double.self, forKey: k) { return v }
        return Lenient.double(try decode(JSON.self, forKey: k))
    }

    public func lenientBool(_ key: String) throws -> Bool? {
        guard let k = try present(key) else { return nil }
        if let v = try? decode(Bool.self, forKey: k) { return v }
        return Lenient.bool(try decode(JSON.self, forKey: k))
    }

    public func lenientString(_ key: String) throws -> String? {
        guard let k = try present(key) else { return nil }
        if let v = try? decode(String.self, forKey: k) { return v }
        return try Lenient.string(decode(JSON.self, forKey: k), codingPath: codingPath + [k])
    }

    /** A nested generated struct; its own `init(from:)` applies these rules to its fields. */
    public func lenientObject<T: Decodable>(_ type: T.Type, _ key: String) throws -> T? {
        guard let k = try present(key) else { return nil }
        return try decode(T.self, forKey: k)
    }

    public func lenientList<T: Decodable>(_ type: T.Type, _ key: String) throws -> [T]? {
        guard let k = try present(key) else { return nil }
        guard Lenient.isScalar(T.self) else { return try decode([T].self, forKey: k) }
        let raw = try decode([JSON].self, forKey: k)
        let path = codingPath + [k]
        return try raw.enumerated().map { i, j in
            try Lenient.element(j, as: T.self, codingPath: path + [AnyCodingKey(intValue: i)!])!
        }
    }

    public func lenientDict<T: Decodable>(_ type: T.Type, _ key: String) throws -> [String: T]? {
        guard let k = try present(key) else { return nil }
        guard Lenient.isScalar(T.self) else { return try decode([String: T].self, forKey: k) }
        let raw = try decode([String: JSON].self, forKey: k)
        let path = codingPath + [k]
        var out = [String: T](minimumCapacity: raw.count)
        for (name, j) in raw {
            out[name] = try Lenient.element(j, as: T.self, codingPath: path + [AnyCodingKey(name)])!
        }
        return out
    }

    /** A raw JSON field (`any`, `object`, unions the generator can't type). */
    public func lenientJSON(_ key: String) throws -> JSON? {
        guard let k = try present(key) else { return nil }
        return try decode(JSON.self, forKey: k)
    }
}
