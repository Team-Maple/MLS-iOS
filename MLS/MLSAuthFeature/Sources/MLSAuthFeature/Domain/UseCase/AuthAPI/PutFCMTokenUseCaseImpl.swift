import Foundation


import RxSwift

public class PutFCMTokenUseCaseImpl: PutFCMTokenUseCase {
    private let repository: AuthAPIRepository

    public init(repository: AuthAPIRepository) {
        self.repository = repository
    }

    public func execute(fcmToken: String?) -> Completable {
        return repository.fcmToken(fcmToken: fcmToken)
    }
}
