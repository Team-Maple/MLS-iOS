import DomainInterface

public struct DictionaryDetailMapNpcResponseDTO: Codable {
    public let npcId: Int?
    public let npcName: String?
    public let npcNameEn: String?
    public let iconUrl: String?

    public func toDomain() -> DictionaryDetailMapNpcResponse {
        return DictionaryDetailMapNpcResponse(npcId: npcId, npcName: npcName, npcNameEn: npcNameEn, iconUrl: iconUrl)
    }
}
