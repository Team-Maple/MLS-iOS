import BaseFeature
import BookmarkFeatureInterface
import DictionaryFeatureInterface
import DomainInterface

public final class BookmarkMainFactoryImpl: BookmarkMainFactory {
    private let getOnBoardingUseCase: GetBookmarkOnboardingUseCase
    private let setOnBoardingUseCase: SetBookmarkOnBoardingUseCase
    private let onBoardingFactory: BookmarkOnBoardingFactory
    private let bookmarkListFactory: BookmarkListFactory
    private let collectionListFactory: CollectionListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory

    public init(
        getOnBoardingUseCase: GetBookmarkOnboardingUseCase,
        setOnBoardingUseCase: SetBookmarkOnBoardingUseCase,
        onBoardingFactory: BookmarkOnBoardingFactory,
        bookmarkListFactory: BookmarkListFactory,
        collectionListFactory: CollectionListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory
    ) {
        self.getOnBoardingUseCase = getOnBoardingUseCase
        self.setOnBoardingUseCase = setOnBoardingUseCase
        self.onBoardingFactory = onBoardingFactory
        self.bookmarkListFactory = bookmarkListFactory
        self.collectionListFactory = collectionListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
    }

    public func make() -> BaseViewController {
        let reactor = BookmarkMainReactor(
            getOnBoardingUseCase: getOnBoardingUseCase,
            setOnBoardingUseCase: setOnBoardingUseCase
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
