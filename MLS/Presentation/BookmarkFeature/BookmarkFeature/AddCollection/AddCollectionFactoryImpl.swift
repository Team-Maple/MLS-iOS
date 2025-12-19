import BaseFeature
import BookmarkFeatureInterface
import DomainInterface

public final class AddCollectionFactoryImpl: AddCollectionFactory {
    private let createCollectionListUseCase: CreateCollectionListUseCase
    private let setCollectionUseCase: UpdateCollectionUseCase

    public init(createCollectionListUseCase: CreateCollectionListUseCase, setCollectionUseCase: UpdateCollectionUseCase) {
        self.createCollectionListUseCase = createCollectionListUseCase
        self.setCollectionUseCase = setCollectionUseCase
    }

    public func make(collection: CollectionResponse?) -> BaseViewController {
        let viewController = AddCollectionViewController()
        viewController.reactor = AddCollectionModalReactor(collection: collection, createCollectionListUseCase: createCollectionListUseCase, setCollectionUseCase: setCollectionUseCase)
        return viewController
    }
}
