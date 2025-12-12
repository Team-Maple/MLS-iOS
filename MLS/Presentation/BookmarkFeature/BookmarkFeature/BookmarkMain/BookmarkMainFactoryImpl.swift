import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkMainFactoryImpl: BookmarkMainFactory {
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let fetchVisitBookmarkUseCase: FetchVisitBookmarkUseCase

    private let onBoardingFactory: BookmarkOnBoardingFactory
    private let bookmarkListFactory: BookmarkListFactory
    private let collectionListFactory: CollectionListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory

    public init(
        setBookmarkUseCase: SetBookmarkUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        fetchVisitBookmarkUseCase: FetchVisitBookmarkUseCase,
        onBoardingFactory: BookmarkOnBoardingFactory,
        bookmarkListFactory: BookmarkListFactory,
        collectionListFactory: CollectionListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory,
        loginFactory: LoginFactory
    ) {
        self.setBookmarkUseCase = setBookmarkUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.fetchVisitBookmarkUseCase = fetchVisitBookmarkUseCase
        self.onBoardingFactory = onBoardingFactory
        self.bookmarkListFactory = bookmarkListFactory
        self.collectionListFactory = collectionListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.loginFactory = loginFactory
    }

    public func make() -> BaseViewController {
        let reactor = BookmarkMainReactor(
            setBookmarkUseCase: setBookmarkUseCase, checkLoginUseCase: checkLoginUseCase, fetchVisitBookmarkUseCase: fetchVisitBookmarkUseCase
        )
        let viewController = BookmarkMainViewController(
            onBoardingFactory: onBoardingFactory,
            bookmarkListFactory: bookmarkListFactory,
            collectionListFactory: collectionListFactory,
            searchFactory: searchFactory,
            notificationFactory: notificationFactory,
            loginFactory: loginFactory,
            reactor: reactor
        )
        return viewController
    }
}
