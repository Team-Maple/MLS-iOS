import Foundation

import RxSwift

public protocol SocialLoginUseCase {
    var provider: any SocialAuthenticatableProvider { get set }

    func execute() -> Observable<Encodable>
}
