import Foundation

import DomainInterface

import RxSwift

public class PutFCMTokenUseCaseImpl: PutFCMTokenUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(credential: String, fcmToken: String?) -> Completable {
        return repository.fcmToken(credential: credential, fcmToken: fcmToken)
    }
}
