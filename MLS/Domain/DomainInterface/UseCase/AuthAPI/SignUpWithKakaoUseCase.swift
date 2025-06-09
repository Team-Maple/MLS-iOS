import Foundation

import RxSwift

public protocol SignUpWithKakaoUseCase {
    func execute(credential: Encodable, isMarketingAgreement: Bool) -> Observable<SignUpResponse>
}
