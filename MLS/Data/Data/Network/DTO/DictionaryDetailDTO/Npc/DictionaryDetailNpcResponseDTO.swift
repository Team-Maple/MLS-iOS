import DomainInterface

public struct DictionaryDetailNpcResponseDTO: Decodable {
    public let npcId: Int
    public let nameKr: String
    public let nameEn: String
    public let iconUrlDetail: String?
    public let bookmarkId: Int?

    public func toDomain() -> DictionaryDetailNpcResponse {
        return DictionaryDetailNpcResponse(npcId: npcId, nameKr: nameKr, nameEn: nameEn, iconUrlDetail: iconUrlDetail, bookmarkId: bookmarkId)
    }
}
