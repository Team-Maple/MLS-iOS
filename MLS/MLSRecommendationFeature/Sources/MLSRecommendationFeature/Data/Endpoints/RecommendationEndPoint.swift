import MLSCore

enum RecommendationEndPoint {
    static let base = "https://mapleland.2megabytes.me"

    static func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> ResponsableEndPoint<RecommendationResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/maps/recommendations",
            method: .GET,
            query: FetchQuery(level: Int32(level), jobId: Int32(jobId), limit: limit.map { Int32($0) })
        )
    }

    static func fetchProfile() -> ResponsableEndPoint<UserProfileResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/auth/me",
            method: .GET
        )
    }

    static func fetchJob(jobId: Int) -> ResponsableEndPoint<JobResponseDTO> {
        .init(
            baseURL: base,
            path: "/api/v1/jobs/\(jobId)",
            method: .GET
        )
    }
}

private extension RecommendationEndPoint {
    struct FetchQuery: Encodable {
        let level: Int32
        let jobId: Int32
        let limit: Int32?
    }
}
