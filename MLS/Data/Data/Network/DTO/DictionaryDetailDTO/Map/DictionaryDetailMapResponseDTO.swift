import DomainInterface

public struct DictionaryDetailMapResponseDTO: Codable {
    public let mapId: Int?
    public let nameKr: String?
    public let nameEn: String?
    public let regionName: String?
    public let detailName: String?
    public let topRegionName: String?
    public let mapUrl: String?
    public let iconUrl: String?
    public let isBookmarked: Bool?

    public func toDomain() -> DictionaryDetailMapResponse {
        return DictionaryDetailMapResponse(mapId: mapId, nameKr: nameKr, nameEn: nameEn, regionName: regionName, detailName: detailName, topRegionName: topRegionName, mapUrl: mapUrl, iconUrl: iconUrl, isBookmarked: isBookmarked)
    }
}
