import MLSBookmarkFeature
import MLSBookmarkFeatureInterface
import MLSBookmarkFeatureTesting
import MLSCore
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        registerDependencies()

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        self.window = window

        let menuVC = MenuViewController()
        let nav = UINavigationController(rootViewController: menuVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    private func registerDependencies() {
        let mockBookmarkRepository = MockBookmarkRepository()
        let mockCollectionRepository = MockCollectionRepository()
        let mockAuthRepository = MockBookmarkAuthRepository()
        let mockUserDefaultsRepository = MockBookmarkUserDefaultsRepository()
        let mockParseUseCase = MockParseItemFilterResultUseCase()

        let addCollectionFactory = AddCollectionFactoryImpl(collectionRepository: mockCollectionRepository)
        let bookmarkModalFactory = BookmarkModalFactoryImpl(
            addCollectionFactory: addCollectionFactory,
            collectionRepository: mockCollectionRepository
        )
        let collectionSettingFactory = CollectionSettingFactoryImpl()
        let collectionEditFactory = CollectionEditFactoryImpl(bookmarkModalFactory: bookmarkModalFactory)
        let collectionDetailFactory = CollectionDetailFactoryImpl(
            bookmarkModalFactory: bookmarkModalFactory,
            collectionSettingFactory: collectionSettingFactory,
            addCollectionFactory: addCollectionFactory,
            collectionEditFactory: collectionEditFactory,
            dictionaryDetailFactory: StubDictionaryDetailFactory(),
            collectionRepository: mockCollectionRepository
        )
        let collectionListFactory = CollectionListFactoryImpl(
            collectionRepository: mockCollectionRepository,
            addCollectionFactory: addCollectionFactory,
            collectionDetailFactory: collectionDetailFactory,
            sortedBottomSheetFactory: StubSortedBottomSheetFactory()
        )
        let bookmarkListFactory = BookmarkListFactoryImpl(
            itemFilterFactory: StubItemFilterBottomSheetFactory(),
            monsterFilterFactory: StubMonsterFilterBottomSheetFactory(),
            sortedFactory: StubSortedBottomSheetFactory(),
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: StubLoginFactory(),
            dictionaryDetailFactory: StubDictionaryDetailFactory(),
            collectionEditFactory: collectionEditFactory,
            authRepository: mockAuthRepository,
            bookmarkRepository: mockBookmarkRepository,
            parseItemFilterResultUseCase: mockParseUseCase
        )
        let onBoardingFactory = BookmarkOnBoardingFactoryImpl()

        DIContainer.register(type: BookmarkMainFactory.self) {
            BookmarkMainFactoryImpl(
                authRepository: mockAuthRepository,
                userDefaultsRepository: mockUserDefaultsRepository,
                onBoardingFactory: onBoardingFactory,
                bookmarkListFactory: bookmarkListFactory,
                collectionListFactory: collectionListFactory,
                searchFactory: StubDictionarySearchFactory(),
                notificationFactory: StubDictionaryNotificationFactory(),
                loginFactory: StubLoginFactory()
            )
        }
        DIContainer.register(type: BookmarkListFactory.self) { bookmarkListFactory }
        DIContainer.register(type: CollectionListFactory.self) { collectionListFactory }
        DIContainer.register(type: CollectionDetailFactory.self) { collectionDetailFactory }
        DIContainer.register(type: BookmarkModalFactory.self) { bookmarkModalFactory }
        DIContainer.register(type: AddCollectionFactory.self) { addCollectionFactory }
        DIContainer.register(type: BookmarkOnBoardingFactory.self) { onBoardingFactory }
    }
}
