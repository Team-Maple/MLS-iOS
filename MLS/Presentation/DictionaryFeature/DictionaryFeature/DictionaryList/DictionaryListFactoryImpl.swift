import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryListFactoryImpl: DictionaryMainListFactory {
    private let checkLoginUseCase: CheckLoginUseCase
    private let dictionaryAllListItemUseCase: FetchDictionaryAllListUseCase
    private let dictionaryMapListItemUseCase: FetchDictionaryMapListUseCase
    private let dictionaryItemListItemUseCase: FetchDictionaryItemListUseCase
    private let dictionaryQuestListItemUseCase: FetchDictionaryQuestListUseCase
    private let dictionaryNpcListItemUseCase: FetchDictionaryNpcListUseCase
    private let dictionaryListItemUseCase: FetchDictionaryMonsterListUseCase
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let detailFactory: DictionaryDetailFactory
    private let loginFactory: () -> LoginFactory

    public init(
        checkLoginUseCase: CheckLoginUseCase,
        dictionaryAllListItemUseCase: FetchDictionaryAllListUseCase,
        dictionaryMapListItemUseCase: FetchDictionaryMapListUseCase,
        dictionaryItemListItemUseCase: FetchDictionaryItemListUseCase,
        dictionaryQuestListItemUseCase: FetchDictionaryQuestListUseCase,
        dictionaryNpcListItemUseCase: FetchDictionaryNpcListUseCase,
        dictionaryListItemUseCase: FetchDictionaryMonsterListUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        detailFactory: DictionaryDetailFactory,
        loginFactory: @escaping () -> LoginFactory
    ) {
        self.checkLoginUseCase = checkLoginUseCase
        self.dictionaryAllListItemUseCase = dictionaryAllListItemUseCase
        self.dictionaryMapListItemUseCase = dictionaryMapListItemUseCase
        self.dictionaryItemListItemUseCase = dictionaryItemListItemUseCase
        self.dictionaryQuestListItemUseCase = dictionaryQuestListItemUseCase
        self.dictionaryNpcListItemUseCase = dictionaryNpcListItemUseCase
        self.dictionaryListItemUseCase = dictionaryListItemUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailFactory = detailFactory
        self.loginFactory = loginFactory
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType, keyword: String? = "") -> BaseViewController {
        let reactor = DictionaryListReactor(
            type: type,
            keyword: keyword,
            checkLoginUseCase: checkLoginUseCase,
            dictionaryAllListUseCase: dictionaryAllListItemUseCase,
            dictionaryMapListUseCase: dictionaryMapListItemUseCase,
            dictionaryItemListUseCase: dictionaryItemListItemUseCase,
            dictionaryQuestListUseCase: dictionaryQuestListItemUseCase,
            dictionaryNpcListUseCase: dictionaryNpcListItemUseCase,
            dictionaryListUseCase: dictionaryListItemUseCase,
            setBookmarkUseCase: setBookmarkUseCase,
            parseItemFilterResultUseCase: parseItemFilterResultUseCase
        )
        let viewController = DictionaryListViewController(
            reactor: reactor,
            itemFilterFactory: itemFilterFactory,
            monsterFilterFactory: monsterFilterFactory,
            sortedFactory: sortedFactory,
            bookmarkModalFactory: bookmarkModalFactory,
            detailFactory: detailFactory,
            loginFactory: loginFactory()
        )
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
