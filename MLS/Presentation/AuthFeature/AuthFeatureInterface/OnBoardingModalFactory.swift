import BaseFeature

public protocol OnBoardingModalFactory {
    func make() -> BaseViewController & ModalPresentable
}
