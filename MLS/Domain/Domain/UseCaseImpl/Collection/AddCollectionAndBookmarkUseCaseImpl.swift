import DomainInterface
import RxSwift

public final class AddCollectionAndBookmarkUseCaseImpl: AddCollectionAndBookmarkUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(collectionIds: [Int], bookmarkIds: [Int]) -> Completable {
        return repository.addCollectionAndBookmark(collectionIds: collectionIds, bookmarkIds: bookmarkIds)
    }
}
