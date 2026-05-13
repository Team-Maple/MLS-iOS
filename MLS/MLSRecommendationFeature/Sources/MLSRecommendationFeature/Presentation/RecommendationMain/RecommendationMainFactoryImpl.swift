import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {
    private let repository: RecommendationRepository
    private let level: Int
    private let jobId: Int

    public init(
        repository: RecommendationRepository,
        level: Int,
        jobId: Int
    ) {
        self.repository = repository
        self.level = level
        self.jobId = jobId
    }

    public func make() -> BaseViewController {
        let vc = RecommendationMainViewController()
        vc.reactor = RecommendationMainReactor(
            repository: repository,
            level: level,
            jobId: jobId
        )
        return vc
    }
}
