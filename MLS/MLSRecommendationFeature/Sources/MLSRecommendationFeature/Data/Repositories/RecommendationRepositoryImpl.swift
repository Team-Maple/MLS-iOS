import MLSCore
import MLSRecommendationFeatureInterface
import RxSwift

public final class RecommendationRepositoryImpl: RecommendationRepository {
    private let provider: NetworkProvider
    private let interceptor: Interceptor?

    public init() {
        self.provider = NetworkProviderImpl()
        self.interceptor = TokenInterceptor()
    }

    public func fetchProfile() -> Observable<UserProfile> {
        let endpoint = RecommendationEndPoint.fetchProfile()
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .compactMap { $0.data?.toDomain() }
    }

    public func fetchJobName(jobId: Int) -> Observable<String> {
        let endpoint = RecommendationEndPoint.fetchJob(jobId: jobId)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .compactMap { $0.data?.jobName }
    }

    public func fetchRecommendations(level: Int, jobId: Int, limit: Int?) -> Observable<[RecommendationMap]> {
        let endpoint = RecommendationEndPoint.fetchRecommendations(level: level, jobId: jobId, limit: limit)
        return provider.requestData(endPoint: endpoint, interceptor: interceptor)
            .map { $0.data?.toDomain() ?? [] }
    }
}
