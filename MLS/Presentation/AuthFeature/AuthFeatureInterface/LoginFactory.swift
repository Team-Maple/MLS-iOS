import BaseFeature

public protocol LoginFactory {
    func make(exitRoute: LoginExitRoute, onLoginCompleted: (() -> Void)?) -> BaseViewController
}

public extension LoginFactory {
    func make(exitRoute: LoginExitRoute) -> BaseViewController {
        make(exitRoute: exitRoute, onLoginCompleted: nil)
    }
}
