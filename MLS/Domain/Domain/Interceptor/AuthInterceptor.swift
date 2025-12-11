import Foundation

import DomainInterface

public final class AuthInterceptor: Interceptor {
    private let tokenRepository: TokenRepository
    private let authRepository: () -> AuthAPIRepository

    public init(tokenRepository: TokenRepository, authRepository: @escaping () -> AuthAPIRepository) {
        self.tokenRepository = tokenRepository
        self.authRepository = authRepository
    }

    public func adapt(_ request: URLRequest) -> URLRequest {
        var request = request
        switch tokenRepository.fetchToken(type: .accessToken) {
        case .success(let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .failure(let error):
            print("Failed to fetch access token: \(error)")
        }
        return request
    }

    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              let url = httpResponse.url else { return false }

        // 🚫 reissue 요청은 retry 금지
        if url.path.contains("/auth/reissue") {
            print("⚠️ reissue 요청에서는 retry 하지 않음")
            return false
        }

        if httpResponse.statusCode == 401 {
            switch tokenRepository.fetchToken(type: .refreshToken) {
            case .success(let refreshToken):
                let authRepo = authRepository()
                authRepo.reissueToken(refreshToken: refreshToken)
                    .subscribe(onNext: { newTokens in
                        _ = self.tokenRepository.saveToken(type: .accessToken, value: newTokens.accessToken)
                        _ = self.tokenRepository.saveToken(type: .refreshToken, value: newTokens.refreshToken)
                        print("✅ 토큰 재발급 성공")
                    }, onError: { error in
                        print("❌ 토큰 재발급 실패: \(error)")
                    })
                    .dispose()
                return true
            case .failure(let error):
                print("Failed to fetch refresh token: \(error)")
                return false
            }
        }

        return false
    }
}
