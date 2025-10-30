import DomainInterface

public struct DictionaryDetailMonsterMapResponseDTO: Decodable {
    public let mapId: Int
    public let mapName: String
    public let regionName: String
    public let detailName: String
    public let topRegionName: String
    public let iconUrl: String
    public let maxSpawnCount: Int?

    public func toDomain() -> DictionaryDetailMonsterMapResponse {
        return DictionaryDetailMonsterMapResponse(mapId: mapId, mapName: mapName, regionName: regionName, detailName: detailName, topRegionName: topRegionName, iconUrl: iconUrl, maxSpawnCount: maxSpawnCount)
    }
}
