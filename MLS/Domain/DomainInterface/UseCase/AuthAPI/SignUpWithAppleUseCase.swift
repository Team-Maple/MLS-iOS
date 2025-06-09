import Foundation

import RxSwift

public protocol SignUpWithAppleUseCase {
    func execute(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse>
}
