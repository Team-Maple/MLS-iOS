import DomainInterface

import RxSwift

public final class SetBookmarkUseCaseImpl: SetBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(bookmarkId: Int, isBookmark: IsBookmark) -> Completable {
        switch isBookmark {
        case .set(let type):
            return repository.setBookmark(bookmarkId: bookmarkId, type: type)
        case .delete:
            return repository.deleteBookmark(bookmarkId: bookmarkId)
        }
    }
}
