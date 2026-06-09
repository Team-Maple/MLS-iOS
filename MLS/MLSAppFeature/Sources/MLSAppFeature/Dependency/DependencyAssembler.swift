import UIKit

import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface
import MLSMyPageFeatureInterface
import MLSRecommendationFeatureInterface

public enum DependencyAssembler {
    @MainActor
    public static func assemble(window: UIWindow?) {
        ProviderAssembly.register()
        RepositoryAssembly.register()
        UseCaseAssembly.register()
        FactoryAssembly.register()

        DIContainer.register(type: AppCoordinatorProtocol.self) {
            AppCoordinator(
                window: window,
                recommendationMainFactory: DIContainer.resolve(
                    type: RecommendationMainFactory.self
                ),
                dictionaryMainViewFactory: DIContainer.resolve(
                    type: DictionaryMainViewFactory.self
                ),
                bookmarkMainFactory: DIContainer.resolve(
                    type: BookmarkMainFactory.self
                ),
                myPageMainFactory: DIContainer.resolve(
                    type: MyPageMainFactory.self
                ),
                loginFactory: DIContainer.resolve(type: LoginFactory.self)
            )
        }
    }
}
