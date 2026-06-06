import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore
import UIKit

public final class BookmarkMainFactoryImpl: BookmarkMainFactory {
    private let authRepository: BookmarkAuthRepository
    private let userDefaultsRepository: BookmarkUserDefaultsRepository
    private let onBoardingFactory: BookmarkOnBoardingFactory
    private let bookmarkListFactory: BookmarkListFactory
    private let collectionListFactory: CollectionListFactory
    private let searchFactory: DictionarySearchFactory
    private let notificationFactory: DictionaryNotificationFactory
    private let loginFactory: LoginFactory

    public init(
        authRepository: BookmarkAuthRepository,
        userDefaultsRepository: BookmarkUserDefaultsRepository,
        onBoardingFactory: BookmarkOnBoardingFactory,
        bookmarkListFactory: BookmarkListFactory,
        collectionListFactory: CollectionListFactory,
        searchFactory: DictionarySearchFactory,
        notificationFactory: DictionaryNotificationFactory,
        loginFactory: LoginFactory
    ) {
        self.authRepository = authRepository
        self.userDefaultsRepository = userDefaultsRepository
        self.onBoardingFactory = onBoardingFactory
        self.bookmarkListFactory = bookmarkListFactory
        self.collectionListFactory = collectionListFactory
        self.searchFactory = searchFactory
        self.notificationFactory = notificationFactory
        self.loginFactory = loginFactory
    }

    public func make(bottomInset: CGFloat = 64) -> BaseViewController {
        let reactor = BookmarkMainReactor(
            authRepository: authRepository,
            userDefaultsRepository: userDefaultsRepository
        )
        return BookmarkMainViewController(
            bottomInset: bottomInset,
            onBoardingFactory: onBoardingFactory,
            bookmarkListFactory: bookmarkListFactory,
            collectionListFactory: collectionListFactory,
            searchFactory: searchFactory,
            notificationFactory: notificationFactory,
            loginFactory: loginFactory,
            reactor: reactor
        )
    }
}
