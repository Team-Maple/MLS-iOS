import MLSCore
import MLSDesignSystem
import MLSMyPageFeatureInterface

public struct SelectImageFactoryImpl: SelectImageFactory {
    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = SelectImageViewContoller()
        viewController.reactor = SelectImageReactor()
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
