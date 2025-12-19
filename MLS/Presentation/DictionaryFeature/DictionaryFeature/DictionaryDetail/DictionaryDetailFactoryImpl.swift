import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

import RxCocoa

public final class DictionaryDetailFactoryImpl: DictionaryDetailFactory {
    private let loginFactory: () -> LoginFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let dictionaryDetailFactory: () -> DictionaryDetailFactory
    private let detailOnBoardingFactory: DetailOnBoardingFactory
    private let appCoordinator: () -> AppCoordinatorProtocol

    private let dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase
    private let dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase
    private let dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase
    private let dictionaryDetailQuestLinkedQuestsUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase
    private let dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase
    private let dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase
    private let dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase
    private let dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase
    private let dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase
    private let dictionaryDetailNpcMapUseCase:
        FetchDictionaryDetailNpcMapUseCase
    private let dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase
    private let dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase
    private let dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchVisitDictionaryDetailUseCase: FetchVisitDictionaryDetailUseCase

    public init(
        loginFactory: @escaping () -> LoginFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        dictionaryDetailFactory: @escaping () -> DictionaryDetailFactory,
        detailOnBoardingFactory: DetailOnBoardingFactory,
        appCoordinator: @escaping () -> AppCoordinatorProtocol,
        dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase,
        dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase,
        dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase,
        dictionaryDetailQuestLinkedQuestsUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase,
        dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase,
        dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase,
        dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase,
        dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase,
        dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase,
        dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase,
        dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase,
        dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase,
        dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchVisitDictionaryDetailUseCase: FetchVisitDictionaryDetailUseCase
    ) {
        self.loginFactory = loginFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailOnBoardingFactory = detailOnBoardingFactory
        self.dictionaryDetailMapUseCase = dictionaryDetailMapUseCase
        self.dictionaryDetailMapSpawnMonsterUseCase = dictionaryDetailMapSpawnMonsterUseCase
        self.dictionaryDetailMapNpcUseCase = dictionaryDetailMapNpcUseCase
        self.dictionaryDetailQuestLinkedQuestsUseCase = dictionaryDetailQuestLinkedQuestsUseCase
        self.dictionaryDetailQuestUseCase = dictionaryDetailQuestUseCase
        self.dictionaryDetailItemDropMonsterUseCase = dictionaryDetailItemDropMonsterUseCase
        self.dictionaryDetailItemUseCase = dictionaryDetailItemUseCase
        self.dictionaryDetailNpcUseCase = dictionaryDetailNpcUseCase
        self.dictionaryDetailNpcQuestUseCase = dictionaryDetailNpcQuestUseCase
        self.dictionaryDetailNpcMapUseCase = dictionaryDetailNpcMapUseCase
        self.dictionaryDetailMonsterUseCase = dictionaryDetailMonsterUseCase
        self.dictionaryDetailMonsterDropItemUseCase = dictionaryDetailMonsterDropItemUseCase
        self.dictionaryDetailMonsterMapUseCase = dictionaryDetailMonsterMapUseCase
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
                dictionaryDetailItemUseCase: dictionaryDetailItemUseCase,
                dictionaryDetailItemDropMonsterUseCase: dictionaryDetailItemDropMonsterUseCase,
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
                dictionaryDetailMonsterUseCase: dictionaryDetailMonsterUseCase,
                dictionaryDetailMonsterDropItemUseCase: dictionaryDetailMonsterDropItemUseCase,
                dictionaryDetailMonsterMapUseCase: dictionaryDetailMonsterMapUseCase,
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
                dictionaryDetailMapUseCase: dictionaryDetailMapUseCase,
                dictionaryDetailMapSpawnMonsterUseCase: dictionaryDetailMapSpawnMonsterUseCase,
                dictionaryDetailMapNpcUseCase: dictionaryDetailMapNpcUseCase,
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
                dictionaryDetailNpcUseCase: dictionaryDetailNpcUseCase,
                dictionaryDetailNpcQuestUseCase: dictionaryDetailNpcQuestUseCase,
                dictionaryDetailNpcMapUseCase: dictionaryDetailNpcMapUseCase,
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
                dictionaryDetailQuestUseCase: dictionaryDetailQuestUseCase,
                dictionaryDetailQuestLinkedQuestUseCase: dictionaryDetailQuestLinkedQuestsUseCase,
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
