import DomainInterface

import RxSwift

public final class FetchBookmarkUseCaseImpl: FetchBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(page: Int, size: Int, sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchBookmark(page: page, size: size, sort: sort?.sortParameter)
    }
}
