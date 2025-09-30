import BaseFeature

public protocol OnBoardingNotificationSheetFactory {
    func make() -> BaseViewController & ModalPresentable
}
