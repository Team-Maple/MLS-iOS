import RxSwift

public protocol SocialLoginUseCase {
    func execute(credential: Credential, platform: LoginPlatform) -> Observable<LoginResponse>
}
