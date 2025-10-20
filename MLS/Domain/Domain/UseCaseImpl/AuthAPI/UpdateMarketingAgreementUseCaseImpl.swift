import Foundation

import DomainInterface

import RxSwift

public class UpdateMarketingAgreementUseCaseImpl: UpdateMarketingAgreementUseCase {
    private let authRepository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(authRepository: AuthAPIRepository, tokenRepository: TokenRepository) {
        self.authRepository = authRepository
        self.tokenRepository = tokenRepository
    }

    public func execute(credential: String, isMarketingAgreement: Bool) -> Completable {
        switch tokenRepository.fetchToken(type: .accessToken) {
        case .success(let token):
            return authRepository.updateMarketingAgreement(credential: token, isMarketingAgreement: isMarketingAgreement)
        case .failure(let error):
            return .error(error)
        }

    }
}
