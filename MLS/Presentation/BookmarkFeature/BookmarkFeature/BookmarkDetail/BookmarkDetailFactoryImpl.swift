import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkDetailFactoryImpl: BookmarkDetailFactory {
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    private let itemFilterBottomSheetFactory: ItemFilterBottomSheetFactory
    private let monsterFilterBottomSheetFactory: MonsterFilterBottomSheetFactory
    private let sortedBottomSheetFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let loginFactory: LoginFactory
    
    public init(toggleBookmarkUseCase: ToggleBookmarkUseCase, itemFilterBottomSheetFactory: ItemFilterBottomSheetFactory, monsterFilterBottomSheetFactory: MonsterFilterBottomSheetFactory, sortedBottomSheetFactory: SortedBottomSheetFactory, bookmarkModalFactory: BookmarkModalFactory, loginFactory: LoginFactory) {
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.itemFilterBottomSheetFactory = itemFilterBottomSheetFactory
        self.monsterFilterBottomSheetFactory = monsterFilterBottomSheetFactory
        self.sortedBottomSheetFactory = sortedBottomSheetFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
    }

    public func make(collection: BookmarkCollection) -> BaseViewController {
        let reactor = BookmarkDetailReactor(toggleBookmarkUseCase: toggleBookmarkUseCase, collection: collection)
        let viewController = BookmarkDetailViewController(reactor: reactor, itemFilterFactory: itemFilterBottomSheetFactory, monsterFilterFactory: monsterFilterBottomSheetFactory, sortedFactory: sortedBottomSheetFactory, bookmarkModalFactory: bookmarkModalFactory, loginFactory: loginFactory)
        return viewController
    }
}
