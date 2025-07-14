import BaseFeature
import DictionaryFeatureInterface
import BookmarkFeatureInterface
import DomainInterface

public final class BookmarkListFactoryImpl: BookmarkListFactory {
    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory

    public init(
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory
    ) {
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = BookmarkListReactor(
            type: type,
            fetchDictionaryItemsUseCase: fetchDictionaryItemsUseCase,
            toggleBookmarkUseCase: toggleBookmarkUseCase
        )
        let viewController = BookmarkListViewController(itemFilterFactory: itemFilterFactory, monsterFilterFactory: monsterFilterFactory, sortedFactory: sortedFactory, bookmarkModalFactory: bookmarkModalFactory)
        viewController.reactor = reactor
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
