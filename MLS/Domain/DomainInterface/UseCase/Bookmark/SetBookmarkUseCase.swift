import RxSwift

public protocol SetBookmarkUseCase {
    func execute(bookmarkId: Int, isBookmark: IsBookmark) -> Completable
}

public enum IsBookmark {
    case set(DictionaryItemType)
    case delete
}
