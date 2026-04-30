import MLSCore
import MLSDesignSystem
import MLSMyPageFeatureInterface

public struct SelectImageFactoryImpl: SelectImageFactory {
    private let myPageRepository: MyPageRepository

    public init(myPageRepository: MyPageRepository) {
        self.myPageRepository = myPageRepository
    }

    public func make() -> BaseViewController & ModalPresentable {
        let viewController = SelectImageViewContoller()
        viewController.reactor = SelectImageReactor(myPageRepository: myPageRepository)
        viewController.isBottomTabbarHidden = true
        return viewController
    }
}
