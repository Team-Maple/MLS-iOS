import MLSAuthFeatureInterface
import MLSBookmarkFeatureInterface
import RxSwift

public final class BookmarkAuthRepositoryImpl: BookmarkAuthRepository {
    private let tokenRepository: TokenRepository
    private let authAPIRepository: AuthAPIRepository

    public init(tokenRepository: TokenRepository, authAPIRepository: AuthAPIRepository) {
        self.tokenRepository = tokenRepository
        self.authAPIRepository = authAPIRepository
    }

    public func isLoggedIn() -> Observable<Bool> {
        switch tokenRepository.fetchToken(type: .refreshToken) {
        case .success(let token):
            guard !token.isEmpty else { return .just(false) }
            return authAPIRepository.reissueToken(refreshToken: token)
                .map { [weak self] response -> Bool in
                    guard let self else { return false }
                    let accessResult = self.tokenRepository.saveToken(type: .accessToken, value: response.accessToken)
                    let refreshResult = self.tokenRepository.saveToken(type: .refreshToken, value: response.refreshToken)
                    switch (accessResult, refreshResult) {
                    case (.success, .success): return true
                    default: return false
                    }
                }
                .catch { _ in .just(false) }
        case .failure:
            return .just(false)
        }
    }
}
