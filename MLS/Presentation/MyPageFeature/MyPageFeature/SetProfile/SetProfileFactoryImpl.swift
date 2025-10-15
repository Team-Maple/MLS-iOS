import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    private let selectImageFactory: SelectImageFactory
    private let checkNickNameUseCase: CheckNickNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase

    public init(selectImageFactory: SelectImageFactory, checkNickNameUseCase: CheckNickNameUseCase, logoutUseCase: LogoutUseCase, withdrawUseCase: WithdrawUseCase) {
        self.selectImageFactory = selectImageFactory
        self.checkNickNameUseCase = checkNickNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
    }

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController(selectImageFactory: selectImageFactory)
        viewController.reactor = SetProfileReactor(checkNickNameUseCase: checkNickNameUseCase, logoutUseCase: logoutUseCase, withdrawUseCase: withdrawUseCase)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
