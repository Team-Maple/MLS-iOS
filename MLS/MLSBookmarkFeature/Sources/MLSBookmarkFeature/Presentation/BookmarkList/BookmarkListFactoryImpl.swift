import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore

public final class BookmarkListFactoryImpl: BookmarkListFactory {
    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let loginFactory: LoginFactory
    private let dictionaryDetailFactory: DictionaryDetailFactory
    private let collectionEditFactory: CollectionEditFactory
    private let authRepository: BookmarkAuthRepository
    private let bookmarkRepository: BookmarkRepository
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    public init(
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        loginFactory: LoginFactory,
        dictionaryDetailFactory: DictionaryDetailFactory,
        collectionEditFactory: CollectionEditFactory,
        authRepository: BookmarkAuthRepository,
        bookmarkRepository: BookmarkRepository,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    ) {
        self.itemFilterFactory = itemFilterFactory
        self.monsterFilterFactory = monsterFilterFactory
        self.sortedFactory = sortedFactory
        self.bookmarkModalFactory = bookmarkModalFactory
        self.loginFactory = loginFactory
        self.dictionaryDetailFactory = dictionaryDetailFactory
        self.collectionEditFactory = collectionEditFactory
        self.authRepository = authRepository
        self.bookmarkRepository = bookmarkRepository
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
    }

    public func make(type: DictionaryType, listType: DictionaryMainViewType) -> BaseViewController {
        let reactor = BookmarkListReactor(
            type: type,
            authRepository: authRepository,
            bookmarkRepository: bookmarkRepository,
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
