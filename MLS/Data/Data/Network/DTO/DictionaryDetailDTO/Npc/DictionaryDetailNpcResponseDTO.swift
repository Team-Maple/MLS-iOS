import DomainInterface

public struct DictionaryDetailNpcResponseDTO: Codable {
    public let npcId: Int
    public let nameKr: String
    public let nameEn: String
    public let iconUrlDetail: String?
    public let isBookmarked: Bool
    
    public func toDomain() -> DictionaryDetailNpcResponse {
        return DictionaryDetailNpcResponse(npcId: npcId, nameKr: nameKr, nameEn: nameEn, iconUrlDetail: iconUrlDetail, isBookmarked: isBookmarked)
    }
}
