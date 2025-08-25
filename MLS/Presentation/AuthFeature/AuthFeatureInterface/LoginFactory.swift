import BaseFeature

public protocol LoginFactory {
    func make(isReLogin: Bool) -> BaseViewController
}
