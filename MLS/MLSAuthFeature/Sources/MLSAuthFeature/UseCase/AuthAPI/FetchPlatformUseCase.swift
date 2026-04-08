import RxSwift

public protocol FetchPlatformUseCase {
    func execute() -> Observable<LoginPlatform?>
}
