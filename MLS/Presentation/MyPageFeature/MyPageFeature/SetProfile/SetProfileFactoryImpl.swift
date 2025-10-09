import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    private let selectImageFactory: SelectImageFactory
    private let checkNickNameUseCase: CheckNickNameUseCase
    private let logoutUseCase: LogoutUseCase

    public init(selectImageFactory: SelectImageFactory, checkNickNameUseCase: CheckNickNameUseCase, logoutUseCase: LogoutUseCase) {
        self.selectImageFactory = selectImageFactory
        self.checkNickNameUseCase = checkNickNameUseCase
        self.logoutUseCase = logoutUseCase
    }

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController(selectImageFactory: selectImageFactory)
        viewController.reactor = SetProfileReactor(checkNickNameUseCase: checkNickNameUseCase, logoutUseCase: logoutUseCase)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
