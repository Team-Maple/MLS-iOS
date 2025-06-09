import BaseFeature

public protocol NotificationFactory {
    func make() -> BaseViewController
}
