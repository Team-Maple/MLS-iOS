import BaseFeature
import MyPageFeatureInterface

public struct SelectImageFactoryImpl: SelectImageFactory {
    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = SelectImageViewContoller()
        viewController.reactor = SelectImageReactor()
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
