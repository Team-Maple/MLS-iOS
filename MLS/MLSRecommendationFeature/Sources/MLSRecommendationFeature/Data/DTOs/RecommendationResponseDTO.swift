struct RecommendationResponseDTO: Decodable {
    let success: Bool
    let code: String?
    let message: String?
    let data: [RecommendationMapDTO]?
}
