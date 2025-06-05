import Foundation

import RxSwift

public protocol SocialLoginUseCase {
    func execute() -> Observable<Encodable>
}
