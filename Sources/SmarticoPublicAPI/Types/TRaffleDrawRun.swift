// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TRaffleDrawRun: Codable, Hashable, Sendable {
    /// Id of the Draw definition, for the repetative draws (e.g. daily), this number will be the same for all draws that are repeating daily
    /// (internal name: schedule_id)
    public var id: Int64?
    /// Field indicates the ID of the latest instance/run of draw
    public var run_id: Int64?
    /// Name of the draw, e.g. 'Daily draw'
    public var name: String?
    /// Description of the draw
    public var description: String?
    /// URL of the image that represents the draw
    /// @remarks Same as {@link TRaffleDraw.image_url}: **365×175 px** desktop promo.
    public var image_url: String?
    /// URL of the moible image that represents the draw
    /// @remarks Same as {@link TRaffleDraw.image_url_mobile}: **300×145 px** mobile promo.
    public var image_url_mobile: String?
    /// URL of the icon that represents the draw
    /// @remarks Same as {@link TRaffleDraw.icon_url}: **256×256 px** square.
    public var icon_url: String?
    /// URL of the background image that will be used in the draw list item
    /// @remarks Same as {@link TRaffleDraw.background_image_url}: **900×85 px**.
    public var background_image_url: String?
    /// URL of the moible background image that will be used in the draw list item
    /// @remarks Same as {@link TRaffleDraw.background_image_url_mobile}: **1328×240 px**.
    public var background_image_url_mobile: String?
    /// Show if the draw is grand and is marked as special
    public var is_grand: Bool?
    /// Date/time of the draw execution
    public var execution_ts: Int64?
    /// Actual Date/time of the draw execution
    public var actual_execution_ts: Int64?
    /// Date/time starting from which the tickets will participate in the upcoming draw
    ///  This value need to be taken into account with next_execute_ts field value, for example
    ///  Next draw is at 10:00, ticket_start_date is 9:00, so all tickets that are collected after 9:00 will participate in the draw at 10:00
    ///  (internally this value is calculated as next_execute_ts - ticket_start_date)
    public var ticket_start_ts: Int64?
    /// Shows if user has won a prize in a current run
    public var is_winner: Bool?
    /// Shows if user has unclaimed prize
    public var has_unclaimed_prize: Bool?

    public init(
        id: Int64? = nil,
        run_id: Int64? = nil,
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        image_url_mobile: String? = nil,
        icon_url: String? = nil,
        background_image_url: String? = nil,
        background_image_url_mobile: String? = nil,
        is_grand: Bool? = nil,
        execution_ts: Int64? = nil,
        actual_execution_ts: Int64? = nil,
        ticket_start_ts: Int64? = nil,
        is_winner: Bool? = nil,
        has_unclaimed_prize: Bool? = nil
    ) {
        self.id = id
        self.run_id = run_id
        self.name = name
        self.description = description
        self.image_url = image_url
        self.image_url_mobile = image_url_mobile
        self.icon_url = icon_url
        self.background_image_url = background_image_url
        self.background_image_url_mobile = background_image_url_mobile
        self.is_grand = is_grand
        self.execution_ts = execution_ts
        self.actual_execution_ts = actual_execution_ts
        self.ticket_start_ts = ticket_start_ts
        self.is_winner = is_winner
        self.has_unclaimed_prize = has_unclaimed_prize
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.run_id = try c.lenientInt64("run_id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.image_url_mobile = try c.lenientString("image_url_mobile")
        self.icon_url = try c.lenientString("icon_url")
        self.background_image_url = try c.lenientString("background_image_url")
        self.background_image_url_mobile = try c.lenientString("background_image_url_mobile")
        self.is_grand = try c.lenientBool("is_grand")
        self.execution_ts = try c.lenientInt64("execution_ts")
        self.actual_execution_ts = try c.lenientInt64("actual_execution_ts")
        self.ticket_start_ts = try c.lenientInt64("ticket_start_ts")
        self.is_winner = try c.lenientBool("is_winner")
        self.has_unclaimed_prize = try c.lenientBool("has_unclaimed_prize")
    }
}
