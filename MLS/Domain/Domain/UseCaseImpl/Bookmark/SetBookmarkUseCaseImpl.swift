import DomainInterface

import RxSwift

public final class SetBookmarkUseCaseImpl: SetBookmarkUseCase {
    private let repository: BookmarkRepository

    public init(repository: BookmarkRepository) {
        self.repository = repository
    }

    public func execute(bookmarkId: Int, isBookmark: IsBookmark) -> Observable<Int?> {
        switch isBookmark {
        case .set(let type):
            return repository
                .setBookmark(bookmarkId: bookmarkId, type: type)
                .map { Optional($0) }
        case .delete:
            return repository.deleteBookmark(bookmarkId: bookmarkId)
        }
    }
}
