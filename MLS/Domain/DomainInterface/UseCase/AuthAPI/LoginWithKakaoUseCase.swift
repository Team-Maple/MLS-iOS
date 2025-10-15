import RxSwift

public protocol LoginWithKakaoUseCase {
    func execute(credential: Credential) -> Observable<LoginResponse>
}
