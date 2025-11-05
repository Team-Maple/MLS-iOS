import UIKit

public enum AppRouter {
    public static func setRoot(_ viewController: UIViewController, animated: Bool = true) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            })
        } else {
            window.rootViewController = viewController
        }

        window.makeKeyAndVisible()
    }
}
