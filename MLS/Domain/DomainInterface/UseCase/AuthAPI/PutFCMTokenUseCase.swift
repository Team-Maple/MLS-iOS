import Foundation

import RxSwift

public protocol PutFCMTokenUseCase {
    func execute(credential: Credential, fcmToken: String?) -> Completable
}
