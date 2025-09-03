import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class DictionaryListFactoryImpl: DictionaryMainListFactory {
    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let detailFactory: DictionaryDetailFactory

    public init(
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        detailFactory: DictionaryDetailFactory
    ) {
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.detailFactory = detailFactory
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = DictionaryListReactor(
            type: type,
            fetchDictionaryItemsUseCase: fetchDictionaryItemsUseCase,
            toggleBookmarkUseCase: toggleBookmarkUseCase
        )
        let viewController = DictionaryListViewController(reactor: reactor, itemFilterFactory: itemFilterFactory, monsterFilterFactory: monsterFilterFactory, sortedFactory: sortedFactory, bookmarkModalFactory: bookmarkModalFactory, detailFactory: detailFactory)
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
