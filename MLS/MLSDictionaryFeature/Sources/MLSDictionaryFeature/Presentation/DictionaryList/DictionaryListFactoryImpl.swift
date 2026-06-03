import MLSAuthFeatureInterface
import MLSCore
import MLSDictionaryFeatureInterface

public final class DictionaryListFactoryImpl: DictionaryMainListFactory {
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    private let dictionaryListAPIRepository: DictionaryListAPIRepository

    private let itemFilterFactory: ItemFilterBottomSheetFactory
    private let monsterFilterFactory: MonsterFilterBottomSheetFactory
    private let sortedFactory: SortedBottomSheetFactory
    private let bookmarkModalFactory: BookmarkModalFactory
    private let detailFactory: DictionaryDetailFactory
    private let loginFactory: () -> LoginFactory

    public init(
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase,
        dictionaryListAPIRepository: DictionaryListAPIRepository,
        itemFilterFactory: ItemFilterBottomSheetFactory,
        monsterFilterFactory: MonsterFilterBottomSheetFactory,
        sortedFactory: SortedBottomSheetFactory,
        bookmarkModalFactory: BookmarkModalFactory,
        detailFactory: DictionaryDetailFactory,
        loginFactory: @escaping () -> LoginFactory
    ) {
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
        self.dictionaryListAPIRepository = dictionaryListAPIRepository
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
            dictionaryListAPIRepository: dictionaryListAPIRepository,
            checkLoginUseCase: checkLoginUseCase,
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
