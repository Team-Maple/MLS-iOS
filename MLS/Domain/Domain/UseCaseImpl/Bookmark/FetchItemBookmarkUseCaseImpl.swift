import DomainInterface

import RxSwift

public final class FetchItemBookmarkUseCaseImpl: FetchItemBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(jobId: Int?, minLevel: Int?, maxLevel: Int?, categoryIds: [Int]?, page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchItemBookmark(jobId: jobId, minLevel: minLevel, maxLevel: maxLevel, categoryIds: categoryIds, page: page ?? 20, size: size ?? 20, sort: sort?.sortParameter)
    }
}
