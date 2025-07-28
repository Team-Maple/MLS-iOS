import Foundation

import DomainInterface

import RxSwift

public class PutFCMTokenUseCaseImpl: PutFCMTokenUseCase {
    private var repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(fcmToken: String?) -> Completable {
        return repository.fcmToken(fcmToken: fcmToken)
    }
}
