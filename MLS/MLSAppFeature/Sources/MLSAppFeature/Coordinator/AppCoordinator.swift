import UIKit

import MLSAppFeatureInterface
import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import MLSDictionaryFeatureInterface
import MLSMyPageFeatureInterface
import MLSRecommendationFeatureInterface

import RxSwift

@MainActor
public final class AppCoordinator: AppCoordinatorProtocol {
    // MARK: - Properties
    public var window: UIWindow?
    private let recommendationMainFactory: RecommendationMainFactory
    private let dictionaryMainViewFactory: DictionaryMainViewFactory
    private let bookmarkMainFactory: BookmarkMainFactory
    private let myPageMainFactory: MyPageMainFactory
    private let loginFactory: LoginFactory

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        window: UIWindow?,
        recommendationMainFactory: RecommendationMainFactory,
        dictionaryMainViewFactory: DictionaryMainViewFactory,
        bookmarkMainFactory: BookmarkMainFactory,
        myPageMainFactory: MyPageMainFactory,
        loginFactory: LoginFactory
    ) {
        self.window = window
        self.recommendationMainFactory = recommendationMainFactory
        self.dictionaryMainViewFactory = dictionaryMainViewFactory
        self.bookmarkMainFactory = bookmarkMainFactory
        self.myPageMainFactory = myPageMainFactory
        self.loginFactory = loginFactory
    }

    // MARK: - Public Methods
    public func showMainTab(selectedIndex: Int = 0) {
        let tabItems: [TabItem] = [
            TabItem(title: "도감", icon: DesignSystemAsset.image(named: "dictionary")),
            TabItem(title: "추천", icon: DesignSystemAsset.image(named: "favorite")
            ),
            TabItem(title: "북마크", icon: DesignSystemAsset.image(named: "bookmarkList")),
            TabItem(title: "MY", icon: DesignSystemAsset.image(named: "mypage"))
        ]
        let tabBar = BottomTabBarController(
            viewControllers: [
                dictionaryMainViewFactory.make(),
                recommendationMainFactory.make(),
                bookmarkMainFactory.make(bottomInset: 64),
                myPageMainFactory.make()
            ],
            tabItems: tabItems,
            initialIndex: selectedIndex
        )

        let navigationController = UINavigationController(rootViewController: tabBar)
        navigationController.isNavigationBarHidden = true
        setRoot(navigationController)
    }

    public func showLogin(exitRoute: LoginExitRoute) {
        let loginVC = loginFactory.make(exitRoute: exitRoute) { [weak self] in
            switch exitRoute {
            case .home:
                self?.showMainTab()
            default:
                break
            }
        }

        let navigationController = UINavigationController(rootViewController: loginVC)
        setRoot(navigationController)
    }

    // MARK: - Private Helper
    private func setRoot(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
