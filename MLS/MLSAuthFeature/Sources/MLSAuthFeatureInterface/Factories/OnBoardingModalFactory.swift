import MLSCore
import MLSDesignSystem

public protocol OnBoardingModalFactory {
    func make() -> BaseViewController & ModalPresentable
}
