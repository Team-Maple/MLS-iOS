import BaseFeature

public protocol OnBoardingNotificationSheetFactory {
    func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController & ModalPresentable
}
