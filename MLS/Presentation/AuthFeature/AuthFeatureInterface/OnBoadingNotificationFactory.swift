import BaseFeature

public protocol OnBoadingNotificationFactory {
    func make(selectedLevel: Int, selectedJobID: Int) -> BaseViewController
}
