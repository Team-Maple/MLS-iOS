import DomainInterface

public struct DictionaryDetailMapSpawnMonsterResponseDTO: Decodable {
    public let monsterId: Int?
    public let monsterName: String?
    public let level: Int?
    public let maxSpawnCount: Int?
    public let imageUrl: String?

    public func toDomain() -> DictionaryDetailMapSpawnMonsterResponse {
        return DictionaryDetailMapSpawnMonsterResponse(monsterId: monsterId, monsterName: monsterName, level: level, maxSpawnCount: maxSpawnCount, imageUrl: imageUrl)
    }
}
