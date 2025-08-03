import Foundation

import RxSwift

public protocol FetchSocialCredentialUseCase {
    func execute() -> Observable<Credential>
}
