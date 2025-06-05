import Foundation

import RxSwift

public protocol LoginWithKakaoUseCase {
    func execute(credential: Encodable) -> Observable<LoginResponse>
}
