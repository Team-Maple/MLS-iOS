import MLSAuthFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

import RxCocoa

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    private let loginFactory: () -> LoginFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let detailOnBoardingFactory: DetailOnBoardingFactory
    private let appCoordinator: () -> AppCoordinatorProtocol
    private let dictionaryDetailAPIRepository: DictionaryDetailAPIRepository
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchVisitDictionaryDetailUseCase: FetchVisitDictionaryDetailUseCase

    public init(
        loginFactory: @escaping () -> LoginFactory,
        bookmarkModalFactory: BookmarkModalFactory,
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
        self.appCoordinator = appCoordinator
        self.dictionaryDetailAPIRepository = dictionaryDetailAPIRepository
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchVisitDictionaryDetailUseCase = fetchVisitDictionaryDetailUseCase
    }

    public func make(
        type: DictionaryType,
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController: BaseViewController

        switch type {
        case .total, .collection:
            viewController = BaseViewController()

        case .item:
            viewController = makeItemViewController(
                id: id,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )

        case .monster:
            viewController = makeMonsterViewController(
                id: id,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )

        case .map:
            viewController = makeMapViewController(
                id: id,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )

        case .npc:
            viewController = makeNpcViewController(
                id: id,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )

        case .quest:
            viewController = makeQuestViewController(
                id: id,
                bookmarkRelay: bookmarkRelay,
                loginRelay: loginRelay
            )
        }

        // 하단 탭바 히든
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}

private extension DictionaryDetailFactoryImpl {
    func makeItemViewController(
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController = ItemDictionaryDetailViewController(
            type: .item,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory(),
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: appCoordinator(),
            fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
            bookmarkRelay: bookmarkRelay,
            loginRelay: loginRelay
        )

        viewController.dictionaryDetailFactory = self

        viewController.reactor = ItemDictionaryDetailReactor(
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            id: id
        )

        return viewController
    }

    func makeMonsterViewController(
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController = MonsterDictionaryDetailViewController(
            type: .monster,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory(),
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: appCoordinator(),
            fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
            bookmarkRelay: bookmarkRelay,
            loginRelay: loginRelay
        )

        viewController.dictionaryDetailFactory = self

        viewController.reactor = MonsterDictionaryDetailReactor(
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            id: id
        )

        return viewController
    }

    func makeMapViewController(
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController = MapDictionaryDetailViewController(
            type: .map,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory(),
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: appCoordinator(),
            fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
            bookmarkRelay: bookmarkRelay,
            loginRelay: loginRelay
        )

        viewController.dictionaryDetailFactory = self

        viewController.reactor = MapDictionaryDetailReactor(
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            id: id
        )

        return viewController
    }

    func makeNpcViewController(
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController = NpcDictionaryDetailViewController(
            type: .npc,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory(),
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: appCoordinator(),
            fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
            bookmarkRelay: bookmarkRelay,
            loginRelay: loginRelay
        )

        viewController.dictionaryDetailFactory = self

        viewController.reactor = NpcDictionaryDetailReactor(
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            id: id
        )

        return viewController
    }

    func makeQuestViewController(
        id: Int,
        bookmarkRelay: PublishRelay<(id: Int, newBookmarkId: Int?)>?,
        loginRelay: PublishRelay<Void>?
    ) -> BaseViewController {
        let viewController = QuestDictionaryDetailViewController(
            type: .quest,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory(),
            detailOnBoardingFactory: detailOnBoardingFactory,
            appCoordinator: appCoordinator(),
            fetchVisitDictionaryDetailUseCase: fetchVisitDictionaryDetailUseCase,
            bookmarkRelay: bookmarkRelay,
            loginRelay: loginRelay
        )

        viewController.dictionaryDetailFactory = self

        viewController.reactor = QuestDictionaryDetailReactor(
            dictionaryDetailAPIRepository: dictionaryDetailAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            id: id
        )

        return viewController
    }
}
