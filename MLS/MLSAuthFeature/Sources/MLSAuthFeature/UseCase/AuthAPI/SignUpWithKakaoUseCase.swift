import RxSwift

public protocol SignUpWithKakaoUseCase {
    func execute(credential: Credential, isMarketingAgreement: Bool, fcmToken: String?) -> Observable<SignUpResponse>
}
