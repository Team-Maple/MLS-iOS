import UIKit

import MLSAppFeatureInterface
import MLSAuthFeatureInterface
import MLSCore

public final class MockAppCoordinator: AppCoordinatorProtocol {
    public var window: UIWindow?

    public init() {}

    public func showMainTab(selectedIndex: Int) {
    }

    public func showLogin(exitRoute: LoginExitRoute) {
    }
}
