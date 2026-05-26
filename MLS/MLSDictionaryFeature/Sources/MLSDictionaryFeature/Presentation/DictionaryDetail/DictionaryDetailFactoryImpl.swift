import MLSAuthFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

import RxCocoa

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    private let loginFactory: () -> LoginFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let dictionaryDetailFactory: () -> DictionaryDetailFactory
    private let detailOnBoardingFactory: DetailOnBoardingFactory
    private let appCoordinator: () -> AppCoordinatorProtocol
    private let dictionaryDetailAPIRepository: DictionaryDetailAPIRepository
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchVisitDictionaryDetailUseCase: FetchVisitDictionaryDetailUseCase

    public init(
        loginFactory: @escaping () -> LoginFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        dictionaryDetailFactory: @escaping () -> DictionaryDetailFactory,
        detailOnBoardingFactory: DetailOnBoardingFactory,
        appCoordinator: @escaping () -> AppCoordinatorProtocol,
        dictionaryDetailAPIRepository: DictionaryDetailAPIRepository,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchVisitDictionaryDetailUseCase: FetchVisitDictionaryDetailUseCase
    ) {
        self.loginFactory = loginFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailOnBoardingFactory = detailOnBoardingFactory
        self.dictionaryDetailAPIRepository = dictionaryDetailAPIRepository
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.appCoordinator = appCoordinator
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.fetchVisitDictionaryDetailUseCase = fetchVisitDictionaryDetailUseCase
    }

    public func make(type: DictionaryType, id: Int, bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?, loginRelay: PublishRelay<Void>?) -> BaseViewController {
        var viewController = BaseViewController()
        switch type {
        case .total:
            break
        case .collection:
            break
        case .item:
            viewController = ItemDictionaryDetailViewController(
                type: .item,
                bookmarkModalFactory: bookmarkModalFactory,
                loginFactory: loginFactory(),
                dictionaryDetailFactory: dictionaryDetailFactory(),
                detailOnBoardingFactory: detailOnBoardingFactory,
                appCoordinator: appCoordinator(), fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
            let reactor = ItemDictionaryDetailReactor(
                dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
                checkLoginUseCase: checkLoginUseCase,
                setBookmarkUseCase: setBookmarkUseCase,
                id: id
            )
            if let viewController = viewController as? ItemDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .monster:
            viewController = MonsterDictionaryDetailViewController(
                type: .monster,
                bookmarkModalFactory: bookmarkModalFactory,
                loginFactory: loginFactory(),
                dictionaryDetailFactory: dictionaryDetailFactory(),
                detailOnBoardingFactory: detailOnBoardingFactory,
                appCoordinator: appCoordinator(), fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
            let reactor = MonsterDictionaryDetailReactor(
                dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
                checkLoginUseCase: checkLoginUseCase,
                setBookmarkUseCase: setBookmarkUseCase,
                id: id
            )
            if let viewController = viewController as? MonsterDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .map:
            viewController = MapDictionaryDetailViewController(
                type: .map,
                bookmarkModalFactory: bookmarkModalFactory,
                loginFactory: loginFactory(),
                dictionaryDetailFactory: dictionaryDetailFactory(),
                detailOnBoardingFactory: detailOnBoardingFactory,
                appCoordinator: appCoordinator(), fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
            let reactor = MapDictionaryDetailReactor(
                dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
                checkLoginUseCase: checkLoginUseCase,
                setBookmarkUseCase: setBookmarkUseCase,
                id: id
            )
            if let viewController = viewController as? MapDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .npc:
            viewController = NpcDictionaryDetailViewController(
                type: .npc,
                bookmarkModalFactory: bookmarkModalFactory,
                loginFactory: loginFactory(),
                dictionaryDetailFactory: dictionaryDetailFactory(),
                detailOnBoardingFactory: detailOnBoardingFactory,
                appCoordinator: appCoordinator(), fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
            let reactor = NpcDictionaryDetailReactor(
                dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
                checkLoginUseCase: checkLoginUseCase,
                setBookmarkUseCase: setBookmarkUseCase,
                id: id
            )
            if let viewController = viewController as? NpcDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        case .quest:
            viewController = QuestDictionaryDetailViewController(
                type: .quest,
                bookmarkModalFactory: bookmarkModalFactory,
                loginFactory: loginFactory(),
                dictionaryDetailFactory: dictionaryDetailFactory(),
                detailOnBoardingFactory: detailOnBoardingFactory,
                appCoordinator: appCoordinator(), fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
            let reactor = QuestDictionaryDetailReactor(
                dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
                checkLoginUseCase: checkLoginUseCase,
                setBookmarkUseCase: setBookmarkUseCase,
                id: id
            )
            if let viewController = viewController as? QuestDictionaryDetailViewController {
                viewController.reactor = reactor
            }
        }

        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
