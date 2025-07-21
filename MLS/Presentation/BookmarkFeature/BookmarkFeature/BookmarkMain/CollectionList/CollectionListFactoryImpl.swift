import BaseFeature
import BookmarkFeatureInterface

public final class CollectionListFactoryImpl: CollectionListFactory {
    private let addCollectionFactory: AddCollectionFactory
    public init(addCollectionFactory: AddCollectionFactory) {
        self.addCollectionFactory = addCollectionFactory
    }

    public func make() -> BaseViewController {
        let reactor = CollectionListReactor()
        let viewController = CollectionListViewController(addCollectionFactory: addCollectionFactory)
        viewController.reactor = reactor
        return viewController
    }
}
