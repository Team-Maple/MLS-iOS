import Foundation

import RxSwift

protocol SignUpWithKakaoUseCase {
    func execute(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse>
}
