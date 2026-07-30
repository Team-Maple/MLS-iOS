import UIKit

import MLSBookmarkFeatureInterface
import MLSCore
import MLSRecommendationFeatureInterface

public struct RecommendationMainFactoryImpl: RecommendationMainFactory {
    private let repository: RecommendationRepository
    private let bookmarkRepository: BookmarkRepository
    private let recommendationUserDefaultsRepository: RecommendationUserDefaultsRepository
    private let makeLoginVC: (() -> UIViewController)?
    private let makeCharacterSettingVC: (() -> UIViewController)?
    private let makeSearchVC: (() -> UIViewController)?
    private let makeNotificationVC: (() -> UIViewController)?
    private let makeDetailVC: ((_ mapId: Int) -> UIViewController)?
    private let makeBookmarkModalVC: ((_ bookmarkIds: [Int], _ onComplete: ((Bool) -> Void)?) -> UIViewController)?

    public init(
        repository: RecommendationRepository,
        bookmarkRepository: BookmarkRepository,
        recommendationUserDefaultsRepository: RecommendationUserDefaultsRepository,
        makeLoginVC: (() -> UIViewController)? = nil,
        makeCharacterSettingVC: (() -> UIViewController)? = nil,
        makeSearchVC: (() -> UIViewController)? = nil,
        makeNotificationVC: (() -> UIViewController)? = nil,
        makeDetailVC: ((_ mapId: Int) -> UIViewController)? = nil,
        makeBookmarkModalVC: ((_ bookmarkIds: [Int], _ onComplete: ((Bool) -> Void)?) -> UIViewController)? = nil
    ) {
        self.repository = repository
        self.bookmarkRepository = bookmarkRepository
        self.recommendationUserDefaultsRepository = recommendationUserDefaultsRepository
        self.makeLoginVC = makeLoginVC
        self.makeCharacterSettingVC = makeCharacterSettingVC
        self.makeSearchVC = makeSearchVC
        self.makeNotificationVC = makeNotificationVC
        self.makeDetailVC = makeDetailVC
        self.makeBookmarkModalVC = makeBookmarkModalVC
    }

    public func make() -> BaseViewController {
        let vc = RecommendationMainViewController()
        vc.reactor = RecommendationMainReactor(repository: repository, bookmarkRepository: bookmarkRepository, userDefaultsRepository: recommendationUserDefaultsRepository)
        vc.onLoginTapped = makeLoginVC
        vc.onEditTapped = makeCharacterSettingVC
        vc.onSearchTapped = makeSearchVC
        vc.onNotificationTapped = makeNotificationVC
        vc.onDetailTapped = makeDetailVC
        vc.onBookmarkModalTapped = makeBookmarkModalVC
        return vc
    }
}
