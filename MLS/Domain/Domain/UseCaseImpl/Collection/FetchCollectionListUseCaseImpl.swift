import DomainInterface

import RxSwift

public final class FetchCollectionListUseCaseImpl: FetchCollectionListUseCase {
    private let repository: CollectionAPIRepository

    public init(repository: CollectionAPIRepository) {
        self.repository = repository
    }

    public func execute(sort: SortType?) -> Observable<[CollectionResponse]> {
        return repository.fetchCollectionList(sort: sort?.sortParameter)
    }
}
