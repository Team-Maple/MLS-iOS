import DomainInterface

public struct DictionaryDetailItemDropMonsterResponseDTO: Decodable {
    public let monsterId: Int?
    public let monsterName: String?
    public let level: Int?
    public let dropRate: Double?
    public let imageUrl: String?

    public func toDomain() -> DictionaryDetailItemDropMonsterResponse {
        return DictionaryDetailItemDropMonsterResponse(monsterId: monsterId, monsterName: monsterName, level: level, dropRate: dropRate, imageUrl: imageUrl)
    }
}
