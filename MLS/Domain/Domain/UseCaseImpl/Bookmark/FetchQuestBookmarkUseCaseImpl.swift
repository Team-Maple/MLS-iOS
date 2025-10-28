import DomainInterface

import RxSwift

public final class FetchQuestBookmarkUseCaseImpl: FetchQuestBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(sort: SortType?) -> Observable<[BookmarkResponse]> {
        return repository.fetchQuestBookmark(sort: sort?.sortParameter)
    }
}
