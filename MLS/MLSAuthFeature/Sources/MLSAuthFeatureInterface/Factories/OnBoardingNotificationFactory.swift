import MLSCore

public protocol OnBoardingNotificationFactory {
    func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController
}
