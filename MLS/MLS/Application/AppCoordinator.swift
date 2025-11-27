import UIKit

import AuthFeature
import AuthFeatureInterface
import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DictionaryFeatureInterface
import MyPageFeatureInterface

import RxSwift

public final class AppCoordinator: AppCoordinatorProtocol {
    // MARK: - Properties
    public var window: UIWindow?
    private let dictionaryMainViewFactory: DictionaryMainViewFactory
    private let bookmarkMainFactory: BookmarkMainFactory
    private let myPageMainFactory: MyPageMainFactory
    private let loginFactory: LoginFactory

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        window: UIWindow?,
        dictionaryMainViewFactory: DictionaryMainViewFactory,
        bookmarkMainFactory: BookmarkMainFactory,
        myPageMainFactory: MyPageMainFactory,
        loginFactory: LoginFactory
    ) {
        self.window = window
        self.dictionaryMainViewFactory = dictionaryMainViewFactory
        self.bookmarkMainFactory = bookmarkMainFactory
        self.myPageMainFactory = myPageMainFactory
        self.loginFactory = loginFactory
    }

    // MARK: - Public Methods
    public func showMainTab() {
        let tabBar = BottomTabBarController(viewControllers: [
            dictionaryMainViewFactory.make(),
            bookmarkMainFactory.make(),
            myPageMainFactory.make()
        ])

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
