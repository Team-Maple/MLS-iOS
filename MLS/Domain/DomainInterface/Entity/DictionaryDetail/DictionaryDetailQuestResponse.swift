public struct DictionaryDetailQuestResponse: Equatable {
    public let questId: Int
    public let titlePrefix: String?
    public let nameKr: String?
    public let nameEn: String?
    public let iconUrl: String?
    public let questType: String?
    public let minLevel: Int?
    public let maxLevel: Int?
    public let requiredMesoStart: Int?
    public let startNpcId: Int?
    public let startNpcName: String?
    public let endNpcId: Int?
    public let endNpcName: String?
    public let reward: Reward?
    public let rewardItems: [RewardItem]?
    public let requirements: [Requirements]?
    public let allowedJobs: [AllowedJob]?
    public var bookmarkId: Int?

    public init(
        questId: Int,
        titlePrefix: String?,
        nameKr: String?,
        nameEn: String?,
        iconUrl: String?,
        questType: String?,
        minLevel: Int?,
        maxLevel: Int?,
        requiredMesoStart: Int?,
        startNpcId: Int?,
        startNpcName: String?,
        endNpcId: Int?,
        endNpcName: String?,
        reward: Reward?,
        rewardItems: [RewardItem]?,
        requirements: [Requirements]?,
        allowedJobs: [AllowedJob]?,
        bookmarkId: Int?
    ) {
        self.questId = questId
        self.titlePrefix = titlePrefix
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.iconUrl = iconUrl
        self.questType = questType
        self.minLevel = minLevel
        self.maxLevel = maxLevel
        self.requiredMesoStart = requiredMesoStart
        self.startNpcId = startNpcId
        self.startNpcName = startNpcName
        self.endNpcId = endNpcId
        self.endNpcName = endNpcName
        self.reward = reward
        self.rewardItems = rewardItems
        self.requirements = requirements
        self.allowedJobs = allowedJobs
        self.bookmarkId = bookmarkId
    }
}

public struct Reward: Decodable, Equatable {
    public let exp: Int?
    public let meso: Int?
    public let popularity: Int?
}

public struct RewardItem: Decodable, Equatable {
    public let itemId: Int?
    public let itemName: String?
    public let quantity: Int?
}

public struct Requirements: Decodable, Equatable {
    public let requirementType: String?
    public let itemId: Int?
    public let itemName: String?
    public let monsterId: Int?
    public let monsterName: String?
    public let quantity: Int?
}

public struct AllowedJob: Decodable, Equatable {
    public let jobId: Int?
    public let jobName: String?
}
