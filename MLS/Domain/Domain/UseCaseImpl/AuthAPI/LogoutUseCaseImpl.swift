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
            
            switch self.repository.deleteToken(type: .accessToken) {
            case .success:
                completable(.completed)
            case .failure(let error):
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}
