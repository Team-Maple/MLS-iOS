public struct DictionaryDetailQuestLinkedQuestsResponse: Equatable {
    public let previousQuests: [Quest]?
    public let nextQuests: [Quest]?

    public init(previousQuests: [Quest]?, nextQuests: [Quest]?) {
        self.previousQuests = previousQuests
        self.nextQuests = nextQuests
    }
}

public struct Quest: Decodable, Equatable {
    public let questId: Int?
    public let name: String?
    public let minLevel: Int?
    public let maxLevel: Int?
    public let iconUrl: String?

    public init(questId: Int?, name: String?, minLevel: Int?, maxLevel: Int?, iconUrl: String?) {
        self.questId = questId
        self.name = name
        self.minLevel = minLevel
        self.maxLevel = maxLevel
        self.iconUrl = iconUrl
    }
}
