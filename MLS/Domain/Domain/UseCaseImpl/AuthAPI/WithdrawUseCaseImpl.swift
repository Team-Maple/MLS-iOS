import Foundation

import DomainInterface

import RxSwift

public class WithdrawUseCaseImpl: WithdrawUseCase {
    private let authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(authRepository: AuthAPIRepository, tokenRepository: TokenRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func execute() -> Completable {
        return authRepository.withdraw()
            .andThen(Completable.deferred { [weak self] in
                guard let self = self else { return .empty() }

                let results: [Result<Void, Error>] = [
                    self.tokenRepository.deleteToken(type: .accessToken),
                    self.tokenRepository.deleteToken(type: .refreshToken)
                ]

                for result in results {
                    if case .failure(let error) = result {
                        return .error(error)
                    }
                }
                return .empty()
            })
    }
}
