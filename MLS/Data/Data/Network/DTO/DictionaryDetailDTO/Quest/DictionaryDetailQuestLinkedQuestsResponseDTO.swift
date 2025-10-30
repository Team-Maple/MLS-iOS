import DomainInterface

public struct DictionaryDetailQuestLinkedQuestsResponseDTO: Decodable {
    public let previousQuests: [Quest]?
    public let nextQuests: [Quest]?

    public func toDomain() -> DictionaryDetailQuestLinkedQuestsResponse {
        return DictionaryDetailQuestLinkedQuestsResponse(previousQuests: previousQuests, nextQuests: nextQuests)
    }
}
