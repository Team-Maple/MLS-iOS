import DomainInterface

import RxSwift

public class CheckLoginUseCaseImpl: CheckLoginUseCase {
    private let authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(authRepository: AuthAPIRepository, tokenRepository: TokenRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func execute() -> Observable<Bool> {
        return .just(true)
    }
}
