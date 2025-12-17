import DomainInterface

import RxSwift

public final class UpdateCollectionUseCaseImpl: UpdateCollectionUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(collectionId: Int, name: String) -> Completable {
        return repository.updateCollectionName(collectionId: collectionId, name: name)
    }
}
