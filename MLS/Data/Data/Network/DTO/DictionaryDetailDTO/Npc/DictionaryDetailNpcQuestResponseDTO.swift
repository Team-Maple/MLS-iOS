import DomainInterface

public struct DictionaryDetailNpcQuestResponseDTO: Decodable {
    public let questId: Int
    public let questNameKr: String
    public let questNameEn: String
    public let questIconUrl: String
    public let minLevel: Int?
    public let maxLevel: Int?

    public func toDomain() -> DictionaryDetailNpcQuestResponse {
        return DictionaryDetailNpcQuestResponse(questId: questId, questNameKr: questNameKr, questNameEn: questNameEn, questIconUrl: questIconUrl, minLevel: minLevel, maxLevel: maxLevel)
    }
}
