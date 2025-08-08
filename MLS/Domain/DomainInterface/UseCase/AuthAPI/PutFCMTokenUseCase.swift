import Foundation

import RxSwift

public protocol PutFCMTokenUseCase {
    func execute(credential: String, fcmToken: String?) -> Completable
}
