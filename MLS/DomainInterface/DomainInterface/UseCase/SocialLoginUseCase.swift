import Foundation

import RxSwift

public protocol SocialLoginUseCase {
    var provider: any SocialAuthenticatable { get set }
    
    func execute() -> Observable<Encodable>
}
