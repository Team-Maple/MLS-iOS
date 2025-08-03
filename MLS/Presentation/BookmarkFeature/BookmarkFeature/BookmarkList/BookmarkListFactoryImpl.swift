import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkListFactoryImpl: BookmarkListFactory {
    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let checkLoginUseCase: CheckLoginUseCase
    private let loginFactory: LoginFactory

    public init(
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        checkLoginUseCase: CheckLoginUseCase,
        loginFactory: LoginFactory
    ) {
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.checkLoginUseCase = checkLoginUseCase
        self.loginFactory = loginFactory
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = BookmarkListReactor(
            type: type,
            fetchDictionaryItemsUseCase: fetchDictionaryItemsUseCase,
            toggleBookmarkUseCase: toggleBookmarkUseCase,
            checkLoginUseCase: checkLoginUseCase
        )
        let viewController = BookmarkListViewController(reactor: reactor, itemFilterFactory: itemFilterFactory, monsterFilterFactory: monsterFilterFactory, sortedFactory: sortedFactory, bookmarkModalFactory: bookmarkModalFactory, loginFactory: loginFactory)
        if listType == .search {
            viewController.isBottomTabbarHidden = true
        }
        return viewController
    }
}
