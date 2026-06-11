import MLSRecommendationFeatureInterface

import RxSwift

/// 모든 요청이 항상 실패하는 Mock
public final class FailingMockRecommendationRepository: RecommendationRepository {

    public init() {}

    public func fetchProfile() -> Observable<UserProfile> {
        return .error(RecommendationRepositoryError.fetchFailed)
    }

    public func fetchJobName(jobId: Int) -> Observable<String> {
        return .error(RecommendationRepositoryError.fetchFailed)
    }

    public func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> Observable<[RecommendationMap]> {
        return .error(RecommendationRepositoryError.fetchFailed)
    }

}

public enum RecommendationRepositoryError: Error {
    case fetchFailed
}
