import RxSwift

public protocol ReissueUseCase {
    func execute(refreshToken: String) -> Observable<LoginResponse>
}
