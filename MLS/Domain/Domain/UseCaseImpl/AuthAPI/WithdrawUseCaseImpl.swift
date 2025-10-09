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
        switch tokenRepository.deleteToken(type: .accessToken) {
        case .success(_):
            return authRepository.withdraw()
        case .failure(let error):
            return .error(error)
        }
        
    }
}
