import RxSwift

public protocol FetchVisitBookmarkUseCase {
    func execute() -> Observable<Bool>
}
