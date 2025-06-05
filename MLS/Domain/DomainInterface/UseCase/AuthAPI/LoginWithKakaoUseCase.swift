import Foundation

import RxSwift

protocol LoginWithKakaoUseCase {
    func execute(credential: Encodable) -> Observable<LoginResponse>
}
