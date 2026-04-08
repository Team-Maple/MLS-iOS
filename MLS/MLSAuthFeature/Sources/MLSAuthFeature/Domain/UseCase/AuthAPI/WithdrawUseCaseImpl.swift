import Foundation


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
            .andThen(Completable.create { [weak self] completable in
                guard let self else {
                    completable(.completed)
                    return Disposables.create()
                }
                _ = self.tokenRepository.deleteToken(type: .accessToken)
                _ = self.tokenRepository.deleteToken(type: .refreshToken)
                _ = self.tokenRepository.deleteToken(type: .fcmToken)
                completable(.completed)
                return Disposables.create()
            })
    }
}
