import BaseFeature
import DomainInterface
import MyPageFeatureInterface

public struct SelectImageFactoryImpl: SelectImageFactory {
    private let updateProfileImageUseCase: UpdateProfileImageUseCase

    public init(updateProfileImageUseCase: UpdateProfileImageUseCase) {
        self.updateProfileImageUseCase = updateProfileImageUseCase
    }

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = SelectImageViewContoller()
        viewController.reactor = SelectImageReactor(updateProfileImageUseCase: updateProfileImageUseCase)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
