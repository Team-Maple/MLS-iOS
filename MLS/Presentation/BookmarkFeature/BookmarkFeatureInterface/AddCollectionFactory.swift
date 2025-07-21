import BaseFeature

public protocol AddCollectionFactory {
    func make(onDismissWithMessage: @escaping (String) -> Void) -> BaseViewController
}
