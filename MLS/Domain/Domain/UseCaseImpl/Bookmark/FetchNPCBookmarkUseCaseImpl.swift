import DomainInterface

import RxSwift

public final class FetchNPCBookmarkUseCaseImpl: FetchNPCBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchNPCBookmark(page: page ?? 20, size: size ?? 20, sort: sort?.sortParameter)
    }
}
