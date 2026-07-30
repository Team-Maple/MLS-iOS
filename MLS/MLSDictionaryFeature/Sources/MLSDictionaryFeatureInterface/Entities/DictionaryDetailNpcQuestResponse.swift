public struct DictionaryDetailNpcQuestResponse: Equatable {
    public let questId: Int
    public let questNameKr: String
    public let questNameEn: String
    public let questIconUrl: String
    public let minLevel: Int?
    public let maxLevel: Int?

    public init(questId: Int, questNameKr: String, questNameEn: String, questIconUrl: String, minLevel: Int?, maxLevel: Int?) {
        self.questId = questId
        self.questNameKr = questNameKr
        self.questNameEn = questNameEn
        self.questIconUrl = questIconUrl
        self.minLevel = minLevel
        self.maxLevel = maxLevel
    }
}
