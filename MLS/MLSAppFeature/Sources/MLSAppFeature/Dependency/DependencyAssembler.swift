import UIKit

import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface
import MLSMyPageFeatureInterface
import MLSRecommendationFeatureInterface

public enum DependencyAssembler {
    public static func register() {
        ProviderAssembly.register()
        RepositoryAssembly.register()
        UseCaseAssembly.register()
        FactoryAssembly.register()
    }

    @MainActor
    public static func launch(window: UIWindow?) {
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
