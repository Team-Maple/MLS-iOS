import RxSwift

public protocol DeleteBookmarkUseCase {
    func execute(bookmarkId: Int) -> Completable
}
