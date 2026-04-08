import UIKit

public protocol AppCoordinatorProtocol: AnyObject {
    var window: UIWindow? { get set }
    func showMainTab()
    func showLogin(exitRoute: LoginExitRoute)
}
