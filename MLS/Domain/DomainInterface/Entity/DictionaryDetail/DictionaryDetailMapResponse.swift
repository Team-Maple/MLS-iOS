public struct DictionaryDetailMapResponse: Codable, Equatable {
    public let mapId: Int?
    public let nameKr: String?
    public let nameEn: String?
    public let regionName: String?
    public let detailName: String?
    public let topRegionName: String?
    public let mapUrl: String?
    public let iconUrl: String?
    public let isBookmarked: Bool?

    public init(mapId: Int?, nameKr: String?, nameEn: String?, regionName: String?, detailName: String?, topRegionName: String?, mapUrl: String?, iconUrl: String?, isBookmarked: Bool?) {
        self.mapId = mapId
        self.nameKr = nameKr
        self.nameEn = nameEn
        self.regionName = regionName
        self.detailName = detailName
        self.topRegionName = topRegionName
        self.mapUrl = mapUrl
        self.iconUrl = iconUrl
        self.isBookmarked = isBookmarked
    }
}
