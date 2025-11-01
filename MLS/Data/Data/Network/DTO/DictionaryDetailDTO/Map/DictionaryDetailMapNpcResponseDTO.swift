import DomainInterface

public struct DictionaryDetailMapNpcResponseDTO: Decodable {
    public let npcId: Int?
    public let npcName: String?
    public let npcNameEn: String?
    public let iconUrl: String?

    public func toDomain() -> DictionaryDetailMapNpcResponse {
        return DictionaryDetailMapNpcResponse(npcId: npcId, npcName: npcName, npcNameEn: npcNameEn, iconUrl: iconUrl)
    }
}
