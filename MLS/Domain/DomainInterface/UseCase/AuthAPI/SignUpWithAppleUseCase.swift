import Foundation

import RxSwift

protocol SignUpWithAppleUseCase {
    func execute(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse>
}
