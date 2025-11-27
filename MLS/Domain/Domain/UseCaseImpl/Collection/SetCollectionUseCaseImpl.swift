import DomainInterface

import RxSwift

public final class SetCollectionUseCaseImpl: SetCollectionUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(collectionId: Int, name: String) -> Completable {
        return repository.setCollectionName(collectionId: collectionId, name: name)
    }
}
