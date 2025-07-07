import BaseFeature
import BookmarkFeatureInterface

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    
    public init() {}

    public func make() -> BaseViewController & ModalPresentable {
        let reactor = AddCollectionReactor()
        let viewController = AddCollectionViewController()
        viewController.reactor = reactor
        return viewController
    }
}
