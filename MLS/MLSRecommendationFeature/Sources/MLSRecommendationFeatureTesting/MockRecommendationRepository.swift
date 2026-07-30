import MLSRecommendationFeatureInterface

import RxSwift

public final class MockRecommendationRepository: RecommendationRepository {

    public init() {}

    public func fetchProfile() -> Observable<UserProfile> {
        return .just(UserProfile(
            nickname: "익명의 판타지",
            jobId: 4,
            level: 275,
            profileImageUrl: ""
        ))
    }

    public func fetchJobName(jobId: Int) -> Observable<String> {
        return .just("도적")
    }

    public func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> Observable<[RecommendationMap]> {
        return .just([
            RecommendationMap(mapId: 100000000, score: 10, iconUrl: "", nameKr: "헤네시스", bookmarkId: nil),
            RecommendationMap(mapId: 100000001, score: 9, iconUrl: "", nameKr: "엘리니아", bookmarkId: 1),
            RecommendationMap(mapId: 100000002, score: 8, iconUrl: "", nameKr: "페리온", bookmarkId: nil),
            RecommendationMap(mapId: 100000003, score: 7, iconUrl: "", nameKr: "슬리피우드", bookmarkId: 2),
            RecommendationMap(mapId: 100000004, score: 6, iconUrl: "", nameKr: "노틸러스 항구", bookmarkId: nil)
        ])
    }
}
