// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct TRafflePrize: Codable, Hashable, Sendable {
    /// The unique identifier for the prize definition
    public var id: String?
    /// Name of the prize
    public var name: String?
    /// Description of the prize
    public var description: String?
    /// URL of the image that represents the prize, 256x256px
    public var image_url: String?
    /// Custom data field set in the backoffice prize setup.
    /// Can be used to build custom UI for gamification.
    public var custom_data: String?
    /// Indicates whether the chance to win should be hidden in the UI.
    /// When `true`, do not render `chances_to_win_perc` for this prize.
    /// Absent means "not hidden".
    public var hide_chance_to_win: Bool?
    /// The number of prizes available per run of the draw.
    /// E.g. if the draw is run daily, this is the number of prizes available each day, for example 3 iPhones.
    public var prizes_per_run: Double?
    /// The actual number of prizes for the current instance.
    /// This value is taking into account follwing values:
    ///  - min_required_total_tickets,
    ///  - add_one_prize_per_each_x_tickets
    ///  - stock_items_per_draw
    ///  - total_tickets_count (from Draw instance)
    ///  - cap_prizes_per_run
    /// For example:
    ///  - prizes_per_run = 1
    ///  - min_required_total_tickets = 1000
    ///  - add_one_prize_per_each_x_tickets = 1000
    ///  - stock_items_per_draw = 5
    ///  - total_tickets_count = 7000
    ///  - cap_prizes_per_run = 6
    ///  prizes_per_run_actual will be 5, because
    ///  7000 tickets are collected, so 7 iPhones are available, but the cap is 6 and the stock is 5.
    public var prizes_per_run_actual: Double?
    /// The chances to win the prize by current player.
    /// Calculated as the ratio of the number of tickets collected by the current player to the
    /// total number of tickets collected by all players and multiplied by number of actual prizes of this kind.
    public var chances_to_win_perc: Double?
    /// The minimum number of total tickets collected during draw period required to unlock the prize.
    /// If the number of tickets collected is less than this value, the prize is not available.
    /// Under total tickets we understand the number of tickets collected by all users.
    /// The 'draw period' is the time between the ticket_start_date value of the draw and the current time.
    public var min_required_total_tickets: Int64?
    /// One additional prize will be awarded for each X tickets.
    /// E.g. if the prize is 1 iPhone and the value is set to 1000, then for every 1000 tickets collected, an additional iPhone is awarded.
    /// If min_required_total_tickets is set to 1000, then next iPhone is awarded when 2000 tickets are collected, and so on.
    /// If min_required_total_tickets is not set, then the next iPhone will be awarded when 1000 tickets are collected.
    public var add_one_prize_per_each_x_tickets: Int64?
    /// Indicates whether the prize requires a claim action from the user.
    public var requires_claim: Bool?
    /// The minimum number of tickets a user must have to be eligible for the prize.
    /// For example iPhone prize may require 10 tickets to be collected, only users with 10 or more tickets will be eligible for the prize.
    /// More tickets are better, as they increase the chances of winning.
    public var min_required_tickets_for_user: Int64?
    /// The maximum number of prizes that can be given withing one instance/run of draw.
    /// For example the prize is iPhone and add_one_prize_per_each_x_tickets is set to 1000,
    /// cap_prizes_per_run is set to 3, and the total number of tickets collected is 7000.
    /// In this case, the prizes_per_run_actual will be limitted by 3
    public var cap_prizes_per_run: Double?
    /// The priority of the prize. The low number means higher priority (e.g. 1 is higher priority than 2).
    /// If there are multiple prizes available, the prize with the highest priority (lowest number) will be awarded first.
    public var priority: Int64?
    /// Optional field that indicates total remaining number of the prize for all draws of the type.
    /// For example, the Daily draw has 1 iPhone daily, and the total number of iPhones is 10.
    /// the stock_items_per_draw will be decreasing by 1 each day (assuming there is enough tickets and it is won every day), and when it reaches 0, the prize is not available anymore.
    public var stock_items_per_draw: Double?
    /// Shows if the prize has been claimed
    public var should_claim: Bool?
    public var winners: [TRafflePrizeWinner]?

    public init(
        id: String? = nil,
        name: String? = nil,
        description: String? = nil,
        image_url: String? = nil,
        custom_data: String? = nil,
        hide_chance_to_win: Bool? = nil,
        prizes_per_run: Double? = nil,
        prizes_per_run_actual: Double? = nil,
        chances_to_win_perc: Double? = nil,
        min_required_total_tickets: Int64? = nil,
        add_one_prize_per_each_x_tickets: Int64? = nil,
        requires_claim: Bool? = nil,
        min_required_tickets_for_user: Int64? = nil,
        cap_prizes_per_run: Double? = nil,
        priority: Int64? = nil,
        stock_items_per_draw: Double? = nil,
        should_claim: Bool? = nil,
        winners: [TRafflePrizeWinner]? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image_url = image_url
        self.custom_data = custom_data
        self.hide_chance_to_win = hide_chance_to_win
        self.prizes_per_run = prizes_per_run
        self.prizes_per_run_actual = prizes_per_run_actual
        self.chances_to_win_perc = chances_to_win_perc
        self.min_required_total_tickets = min_required_total_tickets
        self.add_one_prize_per_each_x_tickets = add_one_prize_per_each_x_tickets
        self.requires_claim = requires_claim
        self.min_required_tickets_for_user = min_required_tickets_for_user
        self.cap_prizes_per_run = cap_prizes_per_run
        self.priority = priority
        self.stock_items_per_draw = stock_items_per_draw
        self.should_claim = should_claim
        self.winners = winners
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientString("id")
        self.name = try c.lenientString("name")
        self.description = try c.lenientString("description")
        self.image_url = try c.lenientString("image_url")
        self.custom_data = try c.lenientString("custom_data")
        self.hide_chance_to_win = try c.lenientBool("hide_chance_to_win")
        self.prizes_per_run = try c.lenientDouble("prizes_per_run")
        self.prizes_per_run_actual = try c.lenientDouble("prizes_per_run_actual")
        self.chances_to_win_perc = try c.lenientDouble("chances_to_win_perc")
        self.min_required_total_tickets = try c.lenientInt64("min_required_total_tickets")
        self.add_one_prize_per_each_x_tickets = try c.lenientInt64("add_one_prize_per_each_x_tickets")
        self.requires_claim = try c.lenientBool("requires_claim")
        self.min_required_tickets_for_user = try c.lenientInt64("min_required_tickets_for_user")
        self.cap_prizes_per_run = try c.lenientDouble("cap_prizes_per_run")
        self.priority = try c.lenientInt64("priority")
        self.stock_items_per_draw = try c.lenientDouble("stock_items_per_draw")
        self.should_claim = try c.lenientBool("should_claim")
        self.winners = try c.lenientList(TRafflePrizeWinner.self, "winners")
    }
}
