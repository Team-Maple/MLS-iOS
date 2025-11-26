import DomainInterface

import RxSwift

public final class DeleteCollectionUseCaseImpl: DeleteCollectionUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(collectionId: Int) -> Completable {
        return repository.deleteCollection(collectionId: collectionId)
    }
}
