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
    private let collectionEditFactory: CollectionEditFactory

    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fetchBookmarkUseCase: FetchBookmarkUseCase
    private let fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase
    private let fetchItemBookmarkUseCase: FetchItemBookmarkUseCase
    private let fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase
    private let fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase
    private let fetchMapBookmarkUseCase: FetchMapBookmarkUseCase
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    public init(
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        loginFactory: LoginFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        collectionEditFactory: CollectionEditFactory,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchProfileUseCase: FetchProfileUseCase,
        fetchBookmarkUseCase: FetchBookmarkUseCase,
        fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase,
        fetchItemBookmarkUseCase: FetchItemBookmarkUseCase,
        fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase,
        fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase,
        fetchMapBookmarkUseCase: FetchMapBookmarkUseCase,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.collectionEditFactory = collectionEditFactory
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.fetchBookmarkUseCase = fetchBookmarkUseCase
        self.fetchNPCBookmarkUseCase = fetchNPCBookmarkUseCase
        self.fetchMonsterBookmarkUseCase = fetchMonsterBookmarkUseCase
        self.fetchItemBookmarkUseCase = fetchItemBookmarkUseCase
        self.fetchQuestBookmarkUseCase = fetchQuestBookmarkUseCase
        self.fetchMapBookmarkUseCase = fetchMapBookmarkUseCase
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = BookmarkListReactor(
            type: type,
            fetchProfileUseCase: fetchProfileUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            fetchBookmarkUseCase: fetchBookmarkUseCase,
            fetchMonsterBookmarkUseCase: fetchMonsterBookmarkUseCase,
            fetchItemBookmarkUseCase: fetchItemBookmarkUseCase,
            fetchNPCBookmarkUseCase: fetchNPCBookmarkUseCase,
            fetchQuestBookmarkUseCase: fetchQuestBookmarkUseCase,
            fetchMapBookmarkUseCase: fetchMapBookmarkUseCase,
            parseItemFilterResultUseCase: parseItemFilterResultUseCase
        )
        let viewController = BookmarkListViewController(
            reactor: reactor,
            itemFilterFactory: itemFilterFactory,
            monsterFilterFactory: monsterFilterFactory,
            sortedFactory: sortedFactory,
            bookmarkModalFactory: bookmarkModalFactory,
            loginFactory: loginFactory,
            dictionaryDetailFactory: dictionaryDetailFactory,
            collectionEditFactory: collectionEditFactory
        )
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
