import DomainInterface

import RxSwift

public final class FetchNPCBookmarkUseCaseImpl: FetchNPCBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchNPCBookmark(sort: sort?.sortParameter)
    }
}
