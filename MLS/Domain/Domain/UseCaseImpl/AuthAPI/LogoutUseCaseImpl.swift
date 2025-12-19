import Foundation

import DomainInterface

import RxSwift

public class LogoutUseCaseImpl: LogoutUseCase {
    private var repository: TokenRepository

    public init(repository: TokenRepository) {
        self.repository = repository
    }

    public func execute() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.completed)
                return Disposables.create()
            }

            let deleteAccess = self.repository.deleteToken(type: .accessToken)
            let deleteRefresh = self.repository.deleteToken(type: .refreshToken)

            guard case .success = deleteAccess, case .success = deleteRefresh else {
                completable(.error(NSError(domain: "LogoutError", code: -1, userInfo: nil)))
                return Disposables.create()
            }

            var fcmToken: String?
            if case .success(let token) = self.repository.fetchToken(type: .fcmToken) {
                fcmToken = token
            }

            if fcmToken != nil {
                _ = self.repository.deleteToken(type: .fcmToken)
            }

            completable(.completed)
            return Disposables.create()
        }
    }
}
