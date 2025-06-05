import Foundation

import RxSwift

protocol LoginWithAppleUseCase {
    func execute(credential: Encodable) -> Observable<LoginResponse>
}
