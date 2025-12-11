import BaseFeature

public protocol PolicyFactory {
    func make(type: PolicyType) -> BaseViewController
}
