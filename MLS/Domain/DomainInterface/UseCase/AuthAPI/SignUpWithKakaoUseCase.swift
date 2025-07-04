import Foundation

import RxSwift

public protocol SignUpWithKakaoUseCase {
    func execute(credential: Credential, isMarketingAgreement: Bool) -> Observable<SignUpResponse>
}
