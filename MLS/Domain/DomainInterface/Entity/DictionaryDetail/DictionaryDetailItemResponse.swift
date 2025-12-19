public struct DictionaryDetailItemResponse: Equatable {
    public let itemId: Int
    public let nameKr: String?
    public let nameEn: String?
    public let descriptionText: String?
    public let imgUrl: String?
    public let npcPrice: Int?
    public let itemType: String?
    public let categoryHierachy: CategoryHierachy?
    public let availableJobs: [Jobs]?
    public let requiredStats: RequiredStats? // 요구 스탯
    public let equipmentStats: EquipmentStats? // 착용하면 올라가는 스탯
    public let scrollDetail: ScrollDetail? // 주문서 상세정보
    public var bookmarkId: Int?

    public init(
        itemId: Int,
        nameKr: String?,
        nameEn: String?,
        descriptionText: String?,
        imgUrl: String?,
        npcPrice: Int?,
        itemType: String?,
        categoryHierachy: CategoryHierachy?,
        availableJobs: [Jobs]?,
        requiredStats: RequiredStats?,
        equipmentStats: EquipmentStats?,
        scrollDetail: ScrollDetail?,
        bookmarkId: Int?
    ) {
        self.itemId = itemId
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.descriptionText = descriptionText
        self.imgUrl = imgUrl
        self.npcPrice = npcPrice
        self.itemType = itemType
        self.categoryHierachy = categoryHierachy
        self.availableJobs = availableJobs
        self.requiredStats = requiredStats
        self.equipmentStats = equipmentStats
        self.scrollDetail = scrollDetail
        self.bookmarkId = bookmarkId
    }

}

public struct CategoryHierachy: Decodable, Equatable {
    public let rootCategory: Category?
    public let leafCategory: Category?
}

public struct Category: Decodable, Equatable {
    public let categoryId: Int?
    public let name: String?
    public let categoryLevel: Int?
    public let description: String?
}

public struct Jobs: Decodable, Equatable {
    public let jobId: Int?
    public let jobName: String?
    public let jobLevel: Int?
    public let parentJobId: Int?
}

public struct RequiredStats: Decodable, Equatable {
    public let level: Int?
    public let str: Int?
    public let dex: Int?
    public let intelligence: Int?
    public let luk: Int?
    public let pop: Int?
}

public struct EquipmentStats: Decodable, Equatable {
    public let str: Stats?
    public let dex: Stats?
    public let intelligence: Stats?
    public let luk: Stats?
    public let hp: Stats?
    public let mp: Stats?
    public let weaponAttack: Stats?
    public let magicAttack: Stats?
    public let physicalDefense: Stats?
    public let magicDefense: Stats?
    public let accuracy: Stats?
    public let evasion: Stats?
    public let speed: Stats?
    public let jump: Stats?
    public let attackSpeed: Int?
    public let attackSpeedDetails: String?
}

public struct Stats: Decodable, Equatable {
    public let base: Int?
    public let min: Int?
    public let max: Int?
}

public struct ScrollDetail: Decodable, Equatable {
    public let successRatePercent: Int?
    public let targetItemTypeText: String?
    public let strChange: Int?
    public let dexChange: Int?
    public let intelligenceChange: Int?
    public let lukChange: Int?
    public let hpChange: Int?
    public let mpChange: Int?
    public let weaponAttackChange: Int?
    public let magicAttackChange: Int?
    public let physicalDefenseChange: Int?
    public let magicDefenseChange: Int?
    public let accuracyChange: Int?
    public let evasionChange: Int?
    public let speedChange: Int?
    public let jumpChange: Int?
}
