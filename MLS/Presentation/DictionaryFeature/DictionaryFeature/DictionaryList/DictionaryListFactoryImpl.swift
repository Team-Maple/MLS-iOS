import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryListFactoryImpl: DictionaryMainListFactory {
    private let dictionaryMapListItemUseCase: FetchDictionaryMapListUseCase
    private let dictionaryItemListItemUseCase: FetchDictionaryItemListUseCase
    private let dictionaryQuestListItemUseCase: FetchDictionaryQuestListUseCase
    private let dictionaryNpcListItemUseCase: FetchDictionaryNpcListUseCase
    private let dictionaryListItemUseCase: FetchDictionaryMonsterListUseCase

    private let setBookmarkUseCase: SetBookmarkUseCase

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let detailFactory: DictionaryDetailFactory

    public init(
        dictionaryMapListItemUseCase: FetchDictionaryMapListUseCase,
        dictionaryItemListItemUseCase: FetchDictionaryItemListUseCase,
        dictionaryQuestListItemUseCase: FetchDictionaryQuestListUseCase,
        dictionaryNpcListItemUseCase: FetchDictionaryNpcListUseCase,
        dictionaryListItemUseCase: FetchDictionaryMonsterListUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        detailFactory: DictionaryDetailFactory
    ) {
        self.dictionaryMapListItemUseCase = dictionaryMapListItemUseCase
        self.dictionaryItemListItemUseCase = dictionaryItemListItemUseCase
        self.dictionaryQuestListItemUseCase = dictionaryQuestListItemUseCase
        self.dictionaryNpcListItemUseCase = dictionaryNpcListItemUseCase
        self.dictionaryListItemUseCase = dictionaryListItemUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailFactory = detailFactory
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = DictionaryListReactor(
            type: type,
            dictionaryMapListUseCase: dictionaryMapListItemUseCase,
            dictionaryItemListUseCase: dictionaryItemListItemUseCase,
            dictionaryQuestListUseCase: dictionaryQuestListItemUseCase,
            dictionaryNpcListUseCase: dictionaryNpcListItemUseCase,
            dictionaryListUseCase: dictionaryListItemUseCase,
            setBookmarkUseCase: setBookmarkUseCase
        )
        let viewController = DictionaryListViewController(reactor: reactor, itemFilterFactory: itemFilterFactory, monsterFilterFactory: monsterFilterFactory, sortedFactory: sortedFactory, bookmarkModalFactory: bookmarkModalFactory, detailFactory: detailFactory)
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
