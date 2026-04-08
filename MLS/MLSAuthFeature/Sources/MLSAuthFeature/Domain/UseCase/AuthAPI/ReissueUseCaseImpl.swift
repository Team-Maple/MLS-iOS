import Foundation


import RxSwift

public final class ReissueUseCaseImpl: ReissueUseCase {
    private let repository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(repository: AuthAPIRepository, tokenRepository: TokenRepository) {
        self.repository = repository
        self.tokenRepository = tokenRepository
    }

    public func execute(refreshToken: String) -> Observable<LoginResponse> {
        return repository.reissueToken(refreshToken: refreshToken)
            .flatMap { [weak self] response -> Observable<LoginResponse> in
                guard let self else { return .empty() }

                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)

                switch (saveAccess, saveRefresh) {
                case (.success, .success):
                    return .just(response)
                default:
                    return .error(TokenRepositoryError.dataConversionError(message: "Failed to save new tokens"))
                }
            }
    }
}
