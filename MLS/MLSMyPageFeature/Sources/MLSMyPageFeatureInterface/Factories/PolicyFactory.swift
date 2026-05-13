import MLSCore

public protocol PolicyFactory {
    func make(type: PolicyType) -> BaseViewController
}
