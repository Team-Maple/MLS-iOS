import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DictionaryFeatureInterface
import MLSRecommendationFeatureInterface
import MyPageFeatureInterface

import RxSwift

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
    public func showMainTab() {
        let tabItems: [TabItem] = [
            TabItem(title: "추천", icon: UIImage(systemName: "star.fill") ?? UIImage()),
            TabItem(title: "도감", icon: DesignSystemAsset.image(named: "dictionary") ?? UIImage()),
            TabItem(title: "북마크", icon: DesignSystemAsset.image(named: "bookmarkList") ?? UIImage()),
            TabItem(title: "MY", icon: DesignSystemAsset.image(named: "mypage") ?? UIImage())
        ]
        let tabBar = BottomTabBarController(
            viewControllers: [
                recommendationMainFactory.make(),
                dictionaryMainViewFactory.make(),
                bookmarkMainFactory.make(),
                myPageMainFactory.make()
            ],
            tabItems: tabItems
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
