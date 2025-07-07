import BaseFeature

public protocol AddCollectionFactory {
    func make() -> BaseViewController & ModalPresentable
}
