import Foundation

import RxSwift

public protocol SignUpWithAppleUseCase {
    func execute(credential: Credential, isMarketingAgreement: Bool?) -> Observable<SignUpResponse>
}
