import Foundation

import DomainInterface

import RxSwift

public final class ReissueUseCaseImpl: ReissueUseCase {
    private let repository: AuthAPIRepository
    private let tokenRepository: TokenRepository

    public init(
        repository: AuthAPIRepository,
        tokenRepository: TokenRepository
    ) {
        self.repository = repository
        self.tokenRepository = tokenRepository
    }

    public func execute(refreshToken: String) -> Observable<LoginResponse> {
        return repository.reissueToken(refreshToken: refreshToken)
            .flatMap { [weak self] response -> Observable<LoginResponse> in
                guard let self = self else { return .empty() }

                let saveAccess = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                let saveRefresh = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)

                switch (saveAccess, saveRefresh) {
                case (.success, .success):
                    print("✅ 새 토큰 저장 완료")
                    return .just(response)
                default:
                    print("❌ 토큰 저장 실패")
                    return .error(TokenRepositoryError.dataConversionError(message: "Failed to save new tokens"))
                }
            }
    }
}
