import RxSwift

public protocol SignUpWithAppleUseCase {
    func execute(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>
}
