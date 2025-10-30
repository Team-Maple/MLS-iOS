import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkMainFactoryImpl: BookmarkMainFactory {
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let onBoardingFactory: BookmarkOnBoardingFactory
    private let bookmarkListFactory: BookmarkListFactory
    private let collectionListFactory: CollectionListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory

    public init(
        setBookmarkUseCase: SetBookmarkUseCase,
        onBoardingFactory: BookmarkOnBoardingFactory,
        bookmarkListFactory: BookmarkListFactory,
        collectionListFactory: CollectionListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory
    ) {
        self.setBookmarkUseCase = setBookmarkUseCase
        self.onBoardingFactory = onBoardingFactory
        self.bookmarkListFactory = bookmarkListFactory
        self.collectionListFactory = collectionListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
    }

    public func make() -> BaseViewController {
        let reactor = BookmarkMainReactor(
            setBookmarkUseCase: setBookmarkUseCase
        )
        let viewController = BookmarkMainViewController(
            onBoardingFactory: onBoardingFactory,
            bookmarkListFactory: bookmarkListFactory,
            collectionListFactory: collectionListFactory,
            searchFactory: searchFactory,
            notificationFactory: notificationFactory,
            reactor: reactor
        )
        return viewController
    }
}
