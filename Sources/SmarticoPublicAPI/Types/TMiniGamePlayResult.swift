// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

/// TMiniGamePlayResult describes the response of
/// `Smartico.api.playMiniGame(template_id)`.
public struct TMiniGamePlayResult: Codable, Hashable, Sendable {
    /// Error code. `0` = success ({@link SAWSpinErrorCode.SAW_OK}).
    /// See `playMiniGame` TSDoc for the full table.
    public var err_code: Int64?
    /// Optional server-side error message. Present only on non-zero
    /// `err_code`; may be empty even then.
    public var err_message: String?
    /// ID of the won prize. Look up in `template.prizes` to interpret
    /// (including `prize_type === 'no-prize'` for a configured loss
    /// slot). Always populated, even when `err_code !== 0`.
    public var prize_id: Int64?
    /// Correlation id of this spin. Pass it to
    /// `miniGameWinAcknowledgeRequest` to finalise the win when
    /// playing with `acknowledge: false` — no need to look it up via
    /// `getMiniGamesHistory`.
    public var request_id: String?

    public init(
        err_code: Int64? = nil,
        err_message: String? = nil,
        prize_id: Int64? = nil,
        request_id: String? = nil
    ) {
        self.err_code = err_code
        self.err_message = err_message
        self.prize_id = prize_id
        self.request_id = request_id
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.err_code = try c.lenientInt64("err_code")
        self.err_message = try c.lenientString("err_message")
        self.prize_id = try c.lenientInt64("prize_id")
        self.request_id = try c.lenientString("request_id")
    }
}
