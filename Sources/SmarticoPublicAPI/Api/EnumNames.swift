import Foundation

/**
 * Wire id → public name mappings. The protocol carries numeric enums while the
 * public API exposes stable string names; these are the `*Named()`
 * helpers, including their "unknown" fallbacks.
 */

func sawGameTypeName(_ id: Int64?) -> String? {
    switch id {
    case SAWGameType.SpinAWheel: return SAWGameTypeName.SpinAWheel
    case SAWGameType.ScratchCard: return SAWGameTypeName.ScratchCard
    case SAWGameType.MatchX: return SAWGameTypeName.MatchX
    case SAWGameType.GiftBox: return SAWGameTypeName.GiftBox
    case SAWGameType.PrizeDrop: return SAWGameTypeName.PrizeDrop
    case SAWGameType.Quiz: return SAWGameTypeName.Quiz
    case SAWGameType.LootboxWeekdays: return SAWGameTypeName.LootboxWeekdays
    case SAWGameType.LootboxCalendarDays: return SAWGameTypeName.LootboxCalendarDays
    case SAWGameType.TreasureHunt: return SAWGameTypeName.TreasureHunt
    case SAWGameType.Voyager: return SAWGameTypeName.Voyager
    case SAWGameType.Plinko: return SAWGameTypeName.Plinko
    case SAWGameType.CoinFlip: return SAWGameTypeName.CoinFlip
    case SAWGameType.CustomMinigame: return SAWGameTypeName.CustomMinigame
    default: return nil
    }
}

func sawBuyInTypeName(_ id: Int64?) -> String {
    switch id {
    case SAWBuyInType.Free: return SAWBuyInTypeName.Free
    case SAWBuyInType.Points: return SAWBuyInTypeName.Points
    case SAWBuyInType.Spins: return SAWBuyInTypeName.Spins
    case SAWBuyInType.Gems: return SAWBuyInTypeName.Gems
    case SAWBuyInType.Diamonds: return SAWBuyInTypeName.Diamonds
    default: return SAWBuyInTypeName.Unknown
    }
}

func sawGameLayoutName(_ id: Int64?) -> String? {
    switch id {
    case SAWGameLayout.Horizontal: return SAWGameLayoutName.Horizontal
    case SAWGameLayout.VerticalMap: return SAWGameLayoutName.VerticalMap
    default: return nil
    }
}

func sawAcknowledgeTypeName(_ id: Int64?) -> String? {
    switch id {
    case SAWAcknowledgeType.Silent: return SAWAcknowledgeTypeName.Silent
    case SAWAcknowledgeType.QuickMessage: return SAWAcknowledgeTypeName.QuickMessage
    case SAWAcknowledgeType.FullMessage: return SAWAcknowledgeTypeName.FullMessage
    case SAWAcknowledgeType.ExplicityAcknowledge: return SAWAcknowledgeTypeName.ExplicityAcknowledge
    default: return nil
    }
}

func miniGamePrizeTypeName(_ id: Int64?) -> String {
    switch id {
    case SAWPrizeType.NO_PRIZE: return MiniGamePrizeTypeName.NO_PRIZE
    case SAWPrizeType.POINTS: return MiniGamePrizeTypeName.POINTS
    case SAWPrizeType.BONUS: return MiniGamePrizeTypeName.BONUS
    case SAWPrizeType.MANUAL: return MiniGamePrizeTypeName.MANUAL
    case SAWPrizeType.SPIN: return MiniGamePrizeTypeName.SPIN
    case SAWPrizeType.JACKPOT: return MiniGamePrizeTypeName.JACKPOT
    case SAWPrizeType.CHANGE_LEVEL: return MiniGamePrizeTypeName.CHANGE_LEVEL
    case SAWPrizeType.MISSION: return MiniGamePrizeTypeName.MISSION
    case SAWPrizeType.RAFFLE_TICKET: return MiniGamePrizeTypeName.RAFFLE_TICKET
    case SAWPrizeType.GEMS_AND_DIAMONDS: return MiniGamePrizeTypeName.GEMS_AND_DIAMONDS
    default: return MiniGamePrizeTypeName.UNKNOWN
    }
}
