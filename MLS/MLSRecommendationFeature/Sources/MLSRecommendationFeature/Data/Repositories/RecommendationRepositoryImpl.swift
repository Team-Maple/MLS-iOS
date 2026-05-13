import MLSCore
import MLSRecommendationFeatureInterface
import RxSwift

final class RecommendationRepositoryImpl: RecommendationRepository {
    private let provider: NetworkProvider
    private let interceptor: Interceptor?

    init(provider: NetworkProvider, interceptor: Interceptor?) {
        self.provider = provider
        self.interceptor = interceptor
    }

    func fetchProfile() -> Observable<UserProfile> {
        let endpoint = RecommendationEndPoint.fetchProfile()
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.toDomain() }
    }

    func fetchJobName(jobId: Int) -> Observable<String> {
        let endpoint = RecommendationEndPoint.fetchJob(jobId: jobId)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.jobName }
    }

    func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> Observable<[RecommendationMap]> {
        let endpoint = RecommendationEndPoint.fetchRecommendations(level: level, jobId: jobId, limit: limit)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.data?.toDomain() ?? [] }
    }
}
