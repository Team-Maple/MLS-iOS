import MLSCore

enum RecommendationEndPoint {
    static let base = "https://mapleland.2megabytes.me"

    static func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> ResponsableEndPoint<RecommendationResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/maps/recommendations",
            method: .GET,
            query: FetchQuery(level: level, jobId: jobId, limit: limit)
        )
    }

    static func fetchProfile() -> ResponsableEndPoint<UserProfileDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/me",
            method: .GET
        )
    }

    static func fetchJob(jobId: Int) -> ResponsableEndPoint<JobDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/jobs/\(jobId)",
            method: .GET
        )
    }
}

private extension RecommendationEndPoint {
    struct FetchQuery: Encodable {
        let level: Int
        let jobId: Int
        let limit: Int?
    }
}
