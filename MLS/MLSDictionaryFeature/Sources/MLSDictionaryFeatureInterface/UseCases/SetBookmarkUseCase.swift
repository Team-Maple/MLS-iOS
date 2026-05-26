import RxSwift

/// Bookmark 모듈 분리 후 삭제 예정
public protocol SetBookmarkUseCase {
    func execute(bookmarkId: Int, isBookmark: IsBookmark) -> Observable<Int?>
}

public enum IsBookmark {
    case set(DictionaryItemType)
    case delete
}
