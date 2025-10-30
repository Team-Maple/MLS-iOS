import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkListFactoryImpl: BookmarkListFactory {
    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let loginFactory: LoginFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory

    private let setBookmarkUseCase: SetBookmarkUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let fetchBookmarkUseCase: FetchBookmarkUseCase
    private let fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase
    private let fetchItemBookmarkUseCase: FetchItemBookmarkUseCase
    private let fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase
    private let fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase
    private let fetchMapBookmarkUseCase: FetchMapBookmarkUseCase

    public init(
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        loginFactory: LoginFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        setBookmarkUseCase: SetBookmarkUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        fetchBookmarkUseCase: FetchBookmarkUseCase,
        fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase,
        fetchItemBookmarkUseCase: FetchItemBookmarkUseCase,
        fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase,
        fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase,
        fetchMapBookmarkUseCase: FetchMapBookmarkUseCase
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.setBookmarkUseCase = setBookmarkUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.fetchBookmarkUseCase = fetchBookmarkUseCase
        self.fetchNPCBookmarkUseCase = fetchNPCBookmarkUseCase
        self.fetchMonsterBookmarkUseCase = fetchMonsterBookmarkUseCase
        self.fetchItemBookmarkUseCase = fetchItemBookmarkUseCase
        self.fetchQuestBookmarkUseCase = fetchQuestBookmarkUseCase
        self.fetchMapBookmarkUseCase = fetchMapBookmarkUseCase
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = BookmarkListReactor(type: type, checkLoginUseCase: checkLoginUseCase, setBookmarkUseCase: setBookmarkUseCase, fetchBookmarkUseCase: fetchBookmarkUseCase, fetchMonsterBookmarkUseCase: fetchMonsterBookmarkUseCase, fetchItemBookmarkUseCase: fetchItemBookmarkUseCase, fetchNPCBookmarkUseCase: fetchNPCBookmarkUseCase, fetchQuestBookmarkUseCase: fetchQuestBookmarkUseCase, fetchMapBookmarkUseCase: fetchMapBookmarkUseCase)
        let viewController = BookmarkListViewController(
            reactor: reactor,
            itemFilterFactory: itemFilterFactory,
            monsterFilterFactory: monsterFilterFactory,
            sortedFactory: sortedFactory,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory,
            dictionaryDetailFactory: dictionaryDetailFactory
        )
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
