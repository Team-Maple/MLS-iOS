import DomainInterface

import RxSwift

public final class FetchMonsterBookmarkUseCaseImpl: FetchMonsterBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(minLevel: Int?, maxLevel: Int?, page: Int?, size: Int?, sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchMonsterBookmark(minLevel: minLevel, maxLevel: maxLevel, page: page ?? 0, size: size ?? 20, sort: sort?.sortParameter)
    }
}
