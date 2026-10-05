import Foundation

/**
 * The typed data surface — `connection.api.getLevels()`, `…getMissions()`, …
 *
 * Methods are declared in extensions in per-domain files (LevelsApi.swift,
 * MissionsApi.swift, …) so the surface stays flat for callers while the source
 * stays split by feature, one file per area of the API.
 */
public final class SmarticoApi: Sendable {
    let conn: SmarticoConnection

    init(conn: SmarticoConnection) {
        self.conn = conn
    }
}

/**
 * Lenient by design: the server adds fields freely, and a strict parser would
 * throw on any payload the generated types don't fully model yet. The
 * leniency lives in the generated types' own `init(from:)` (see
 * Serialization/Lenient.swift), so the decoder itself needs no options.
 */
let apiDecoder = JSONDecoder()

extension SmarticoApi {
    /** Send a request and decode the response into `T`. The building block of every method. */
    func call<T: Decodable>(
        cid: Int,
        expectCid: Int,
        _ type: T.Type,
        payload: JSONObject = [:]
    ) async throws -> T {
        let raw = try await conn.request(cid: cid, expectCid: expectCid, payload: payload)
        do {
            return try apiDecoder.decode(T.self, from: JSON.object(raw).data(sortedKeys: false))
        } catch {
            throw SmarticoError.decoding(error)
        }
    }
}
