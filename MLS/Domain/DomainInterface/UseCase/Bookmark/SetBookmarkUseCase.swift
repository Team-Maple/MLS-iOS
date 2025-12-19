import RxSwift

public protocol SetBookmarkUseCase {
    func execute(bookmarkId: Int, isBookmark: IsBookmark) -> Observable<Int?>
}

public enum IsBookmark {
    case set(DictionaryItemType)
    case delete
}
