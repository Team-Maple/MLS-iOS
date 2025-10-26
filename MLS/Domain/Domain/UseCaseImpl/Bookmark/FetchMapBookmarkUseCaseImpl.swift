import DomainInterface

import RxSwift

public final class FetchMapBookmarkUseCaseImpl: FetchMapBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchMapBookmark(sort: sort?.sortParameter)
    }
}
