import RxSwift

public protocol BookmarkAuthRepository {
    func isLoggedIn() -> Observable<Bool>
}
