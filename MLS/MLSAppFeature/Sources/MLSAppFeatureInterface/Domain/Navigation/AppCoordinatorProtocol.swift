import MLSCore
import UIKit

@MainActor
public protocol AppCoordinatorProtocol: AnyObject {
    var window: UIWindow? { get set }
    func showMainTab(selectedIndex: Int)
    func showLogin(exitRoute: LoginExitRoute)
}

public extension AppCoordinatorProtocol {
    func showMainTab() {
        showMainTab(selectedIndex: 0)
    }
}
