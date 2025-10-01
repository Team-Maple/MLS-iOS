import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public final class SetProfileFactoryImpl: SetProfileFactory {
    private let selectImageFactory: SelectImageFactory
    private let checkNickNameUseCase: CheckNickNameUseCase
    private let updateNickNameUseCase: UpdateNickNameUseCase

    public init(selectImageFactory: SelectImageFactory, checkNickNameUseCase: CheckNickNameUseCase, updateNickNameUseCase: UpdateNickNameUseCase) {
        self.selectImageFactory = selectImageFactory
        self.checkNickNameUseCase = checkNickNameUseCase
        self.updateNickNameUseCase = updateNickNameUseCase
    }

    public func make() -> BaseViewController {
        let viewController = SetProfileViewController(selectImageFactory: selectImageFactory)
        viewController.reactor = SetProfileReactor(checkNickNameUseCase: checkNickNameUseCase, updateNickNameUseCase: updateNickNameUseCase)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
