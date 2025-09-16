import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    private let selectImageFactory: SelectImageFactory
    private let checkNickNameUseCase: CheckNickNameUseCase
    
    public init(selectImageFactory: SelectImageFactory, checkNickNameUseCase: CheckNickNameUseCase) {
        self.selectImageFactory = selectImageFactory
        self.checkNickNameUseCase = checkNickNameUseCase
    }

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController(selectImageFactory: selectImageFactory)
        viewController.reactor = SetProfileReactor(checkNickNameUseCase: checkNickNameUseCase)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
