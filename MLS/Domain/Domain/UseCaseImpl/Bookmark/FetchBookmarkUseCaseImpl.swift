import DomainInterface

import RxSwift

public final class FetchBookmarkUseCaseImpl: FetchBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchBookmark(sort: sort?.sortParameter)
    }
}
