// GENERATED from @smartico/public-api 0.0.434 — DO NOT EDIT.
// Regenerate: cd codegen && npm run gen

import Foundation

public struct Bonus: Codable, Hashable, Sendable {
    public var id: Int64?
    public var redeemable: Bool?
    public var createDate: String?
    public var updateDate: String?
    public var redeemDate: String?
    public var engagementUid: String?
    public var labelBonusTemplateId: Double?
    public var sourceProductRefId: Double?
    public var sourceProductId: Double?
    public var userId: Double?
    public var bonusStatusId: Int64?
    public var labelBonusTemplateMetaMap: BonusTemplateMetaMap?
    public var bonusMetaMap: BonusMetaMap?

    public init(
        id: Int64? = nil,
        redeemable: Bool? = nil,
        createDate: String? = nil,
        updateDate: String? = nil,
        redeemDate: String? = nil,
        engagementUid: String? = nil,
        labelBonusTemplateId: Double? = nil,
        sourceProductRefId: Double? = nil,
        sourceProductId: Double? = nil,
        userId: Double? = nil,
        bonusStatusId: Int64? = nil,
        labelBonusTemplateMetaMap: BonusTemplateMetaMap? = nil,
        bonusMetaMap: BonusMetaMap? = nil
    ) {
        self.id = id
        self.redeemable = redeemable
        self.createDate = createDate
        self.updateDate = updateDate
        self.redeemDate = redeemDate
        self.engagementUid = engagementUid
        self.labelBonusTemplateId = labelBonusTemplateId
        self.sourceProductRefId = sourceProductRefId
        self.sourceProductId = sourceProductId
        self.userId = userId
        self.bonusStatusId = bonusStatusId
        self.labelBonusTemplateMetaMap = labelBonusTemplateMetaMap
        self.bonusMetaMap = bonusMetaMap
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: AnyCodingKey.self)
        self.id = try c.lenientInt64("id")
        self.redeemable = try c.lenientBool("redeemable")
        self.createDate = try c.lenientString("createDate")
        self.updateDate = try c.lenientString("updateDate")
        self.redeemDate = try c.lenientString("redeemDate")
        self.engagementUid = try c.lenientString("engagementUid")
        self.labelBonusTemplateId = try c.lenientDouble("labelBonusTemplateId")
        self.sourceProductRefId = try c.lenientDouble("sourceProductRefId")
        self.sourceProductId = try c.lenientDouble("sourceProductId")
        self.userId = try c.lenientDouble("userId")
        self.bonusStatusId = try c.lenientInt64("bonusStatusId")
        self.labelBonusTemplateMetaMap = try c.lenientObject(BonusTemplateMetaMap.self, "labelBonusTemplateMetaMap")
        self.bonusMetaMap = try c.lenientObject(BonusMetaMap.self, "bonusMetaMap")
    }
}
