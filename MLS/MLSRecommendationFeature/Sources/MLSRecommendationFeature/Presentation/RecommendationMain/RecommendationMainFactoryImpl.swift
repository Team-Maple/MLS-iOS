import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {
    private let repository: RecommendationRepository

    public init(repository: RecommendationRepository) {
        self.repository = repository
    }

    public func make() -> BaseViewController {
        let vc = RecommendationMainViewController()
        vc.reactor = RecommendationMainReactor(repository: repository)
        return vc
    }
}
