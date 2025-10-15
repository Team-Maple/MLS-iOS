import BaseFeature

public protocol OnBoardingNotificationFactory {
    func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController
}
