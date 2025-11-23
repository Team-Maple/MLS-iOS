import DomainInterface

import RxSwift

public final class FetchCollectionUseCaseImpl: FetchCollectionUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(id: Int) -> Observable<[BookmarkResponse]> {
        return repository.fetchCollectionUseCase(id: id)
    }
}
