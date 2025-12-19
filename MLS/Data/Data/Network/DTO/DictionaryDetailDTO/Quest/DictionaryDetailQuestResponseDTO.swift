import DomainInterface

public struct DictionaryDetailQuestResponseDTO: Decodable {
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
    public let bookmarkId: Int?

    public func toDomain() -> DictionaryDetailQuestResponse {
        return DictionaryDetailQuestResponse(
            questId: questId,
            titlePrefix: titlePrefix,
            nameKr: nameKr,
            nameEn: nameEn,
            iconUrl: iconUrl,
            questType: questType,
            minLevel: minLevel,
            maxLevel: maxLevel,
            requiredMesoStart: requiredMesoStart,
            startNpcId: startNpcId,
            startNpcName: startNpcName,
            endNpcId: endNpcId,
            endNpcName: endNpcName,
            reward: reward,
            rewardItems: rewardItems,
            requirements: requirements,
            allowedJobs: allowedJobs,
            bookmarkId: bookmarkId
        )
    }
}
