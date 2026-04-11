import RxSwift

public protocol SocialSignUpUseCase {
    func execute(credential: Credential, platform: LoginPlatform, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>
}
