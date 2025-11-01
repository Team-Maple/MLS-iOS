public struct DictionaryDetailMonsterMapResponse: Equatable {
    public let mapId: Int
    public let mapName: String
    public let regionName: String
    public let detailName: String
    public let topRegionName: String
    public let iconUrl: String
    public let maxSpawnCount: Int?

    public init(mapId: Int, mapName: String, regionName: String, detailName: String, topRegionName: String, iconUrl: String, maxSpawnCount: Int?) {
        self.mapId = mapId
        self.mapName = mapName
        self.regionName = regionName
        self.detailName = detailName
        self.topRegionName = topRegionName
        self.iconUrl = iconUrl
        self.maxSpawnCount = maxSpawnCount
    }
}
