import Foundation

import RxSwift

public protocol LoginWithAppleUseCase {
    func execute(credential: Encodable) -> Observable<LoginResponse>
}
