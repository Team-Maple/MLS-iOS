import DomainInterface

public struct DictionaryDetailMonsterDropItemResponseDTO: Decodable {
    public let itemId: Int
    public let itemName: String
    public let dropRate: Double
    public let imageUrl: String
    public let itemLevel: Int

    public func toDomain() -> DictionaryDetailMonsterDropItemResponse {
        DictionaryDetailMonsterDropItemResponse(itemId: itemId, itemName: itemName, dropRate: dropRate, imageUrl: imageUrl, itemLevel: itemLevel)
    }
}
