import RxSwift

public protocol FetchProfileUseCase {
    func execute() -> Observable<MyPageResponse?>
}
