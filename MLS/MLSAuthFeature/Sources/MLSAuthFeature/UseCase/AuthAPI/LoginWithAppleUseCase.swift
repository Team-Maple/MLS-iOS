import RxSwift

public protocol LoginWithAppleUseCase {
    func execute(credential: Credential) -> Observable<LoginResponse>
}
