import UIKit

import MLSAuthFeatureTesting
import MLSDictionaryFeature
import MLSDictionaryFeatureInterface
import MLSDictionaryFeatureTesting
import MLSMyPageFeatureTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let rootVC = makeDictionaryViewController()
        let nav = UINavigationController(rootViewController: rootVC)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func makeDictionaryViewController() -> UIViewController {
        // MARK: - Repository
        let dictionaryListAPIRepository = MockDictionaryListAPIRepository()
        let dictionaryDetailAPIRepository = MockDictionaryDetailAPIRepository()
        let recentSearchRepository = MockRecentSearchRepository()
        let bookmarkRepository = MockBookmarkRepository()
        let authRepository = MockAuthAPIRepository()
        let tokenRepository = MockTokenRepository()
        let alarmRepository = MockAlarmRepository()

        // MARK: - UseCase
        let checkLoginUseCase = CheckLoginUseCaseImpl(
            authRepository: authRepository,
            tokenRepository: tokenRepository
        )
        let parseItemFilterResultUseCase = ParseItemFilterResultUseCaseImpl()
        let fetchVisitDictionaryDetailUseCase =
            FetchVisitDictionaryDetailUseCaseImpl(
                repository: UserDefaultsRepositoryImpl()
            )
        let fetchProfileUseCase = MockFetchProfileUseCase()
        let checkNotificationPermissionUseCase =
            CheckNotificationPermissionUseCaseImpl()

        // MARK: - Factory
        let loginFactory = MockLoginFactory()
        let bookmarkModalFactory = MockBookmarkModalFactory()
        let itemFilterFactory = ItemFilterBottomSheetFactoryImpl()
        let monsterFilterFactory = MonsterFilterBottomSheetFactoryImpl()
        let sortedFactory = SortedBottomSheetFactoryImpl()
        let detailOnBoardingFactory = DetailOnBoardingFactoryImpl()
        let notificationSettingFactory =
            MockNotificationSettingFactory()

        // MARK: - Detail Factory
        let detailFactory = DictionaryDetailFactoryImpl(
            loginFactory: {
                loginFactory
            },
            bookmarkModalFactory: bookmarkModalFactory,
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: {
                MockAppCoordinator()
            },
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            bookmarkRepository: bookmarkRepository,
            checkLoginUseCase: checkLoginUseCase,
            fetchVisitDictionaryDetailUseCase:
            fetchVisitDictionaryDetailUseCase
        )

        // MARK: - Dictionary Main List Factory
        let dictionaryMainListFactory = DictionaryListFactoryImpl(
            checkLoginUseCase: checkLoginUseCase,
            bookmarkRepository: bookmarkRepository,
            parseItemFilterResultUseCase:
            parseItemFilterResultUseCase,
            dictionaryListAPIRepository:
            dictionaryListAPIRepository,
            itemFilterFactory: itemFilterFactory,
            monsterFilterFactory: monsterFilterFactory,
            sortedFactory: sortedFactory,
            bookmarkModalFactory: bookmarkModalFactory,
            detailFactory: detailFactory
        ) {
            MockLoginFactory()
        }

        // MARK: - Search Factory
        let dictionarySearchResultFactory =
            DictionarySearchResultFactoryImpl(
                dictionaryListAPIRepository:
                dictionaryListAPIRepository,
                recentSearchRepository:
                recentSearchRepository,
                dictionaryMainListFactory:
                dictionaryMainListFactory
            )
        let dictionarySearchFactory =
            DictionarySearchFactoryImpl(
                recentSearchRepository:
                recentSearchRepository,
                searchResultFactory:
                dictionarySearchResultFactory
            )

        // MARK: - Notification Factory
        let dictionaryNotificationFactory =
            DictionaryNotificationFactoryImpl(
                notificationSettingFactory:
                notificationSettingFactory,
                fetchProfileUseCase:
                fetchProfileUseCase,
                checkNotificationPermissionUseCase:
                checkNotificationPermissionUseCase,
                alarmRepository:
                alarmRepository
            )

        // MARK: - Main Factory
        let dictionaryFactory = DictionaryMainViewFactoryImpl(
            dictionaryMainListFactory:
            dictionaryMainListFactory,
            searchFactory:
            dictionarySearchFactory,
            notificationFactory:
            dictionaryNotificationFactory,
            loginFactory:
            loginFactory,
            fetchProfileUseCase:
            fetchProfileUseCase
        )

        return dictionaryFactory.make()
    }
}
