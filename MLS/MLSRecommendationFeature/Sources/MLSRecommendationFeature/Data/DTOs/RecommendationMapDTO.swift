import MLSRecommendationFeatureInterface

struct RecommendationMapDTO: Decodable {
    let mapId: Int
    let score: Double
    let iconUrl: String
    let nameKr: String
    let bookmarkId: Int?
}

extension RecommendationMapDTO {
    func toDomain() -> RecommendationMap {
        RecommendationMap(
            mapId: mapId,
            score: score,
            iconUrl: iconUrl,
            nameKr: nameKr,
            bookmarkId: bookmarkId
        )
    }
}

extension Array where Element == RecommendationMapDTO {
    func toDomain() -> [RecommendationMap] {
        map { $0.toDomain() }
    }
}
