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
        if case .success(let token) = tokenRepository.fetchToken(type: .accessToken) {
            #if DEBUG
            print("accessToken: \(token)")
            #endif
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    public func retry(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
              let url = httpResponse.url else { return false }

        if url.path.contains("/auth/reissue") {
            print("⚠️ reissue 요청에서는 retry 하지 않음")
            return false
        }

        if httpResponse.statusCode == 401 {
            if case .success(let refreshToken) = tokenRepository.fetchToken(type: .refreshToken) {
                let repo = authRepository()
                repo.reissueToken(refreshToken: refreshToken)
                    .subscribe(onNext: { _ in
                        print("✅ reissue 완료")
                    }, onError: { error in
                        print("❌ reissue 실패: \(error)")
                    })
                    .dispose()
                return true
            }
        }
        return false
    }
}
