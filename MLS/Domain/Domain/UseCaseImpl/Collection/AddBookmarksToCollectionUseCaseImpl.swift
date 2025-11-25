import DomainInterface

import RxSwift

public final class AddBookmarksToCollectionUseCaseImpl: AddBookmarksToCollectionUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(collectionId: Int, bookmarkIds: [Int]) -> Completable {
        return repository.addBookmarksToCollection(collectionId: collectionId, bookmarkIds: bookmarkIds)
    }
}
