public struct DictionaryDetailQuestResponse: Codable, Equatable {
    public let questId: Int?
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
    public let isBookmarked: Bool?
    
    public init(questId: Int?, titlePrefix: String?, nameKr: String?, nameEn: String?, iconUrl: String?, questType: String?, minLevel: Int?, maxLevel: Int?, requiredMesoStart: Int?, startNpcId: Int?, startNpcName: String?, endNpcId: Int?, endNpcName: String?, reward: Reward?, rewardItems: [RewardItem]?, requirements: [Requirements]?, allowedJobs: [AllowedJob]?, isBookmarked: Bool?) {
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
        self.isBookmarked = isBookmarked
    }
}

public struct Reward: Codable, Equatable {
    public let exp: Int?
    public let meso: Int?
    public let popularity: Int?
    
    init(exp: Int?, meso: Int?, popularity: Int?) {
        self.exp = exp
        self.meso = meso
        self.popularity = popularity
    }
}

public struct RewardItem: Codable, Equatable {
    public let itemId: Int?
    public let itemName: String?
    public let quantity: Int?
    
    init(itemId: Int?, itemName: String?, quantity: Int?) {
        self.itemId = itemId
        self.itemName = itemName
        self.quantity = quantity
    }
}

public struct Requirements: Codable, Equatable {
    public let requirementType: String?
    public let itemId: Int?
    public let itemName: String?
    public let monsterId: Int?
    public let monsterName: String?
    public let quantity: Int?
    
    init(requirementType: String?, itemId: Int?, itemName: String?, monsterId: Int?, monsterName: String?, quantity: Int?) {
        self.requirementType = requirementType
        self.itemId = itemId
        self.itemName = itemName
        self.monsterId = monsterId
        self.monsterName = monsterName
        self.quantity = quantity
    }
}

public struct AllowedJob: Codable, Equatable {
    public let jobId: Int?
    public let jobName: String?
    
    init(jobId: Int?, jobName: String?) {
        self.jobId = jobId
        self.jobName = jobName
    }
}
