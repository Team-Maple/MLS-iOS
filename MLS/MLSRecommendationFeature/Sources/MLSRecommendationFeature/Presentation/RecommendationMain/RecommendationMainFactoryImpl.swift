import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {

    public init() {}

    public func make() -> BaseViewController {
        return RecommendationMainViewController()
    }
}
