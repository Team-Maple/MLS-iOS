import BaseFeature

public protocol SelectImageFactory {
    func make() -> BaseViewController & ModalPresentable
}
