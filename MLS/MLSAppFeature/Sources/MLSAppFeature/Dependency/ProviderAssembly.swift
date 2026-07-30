import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSCore

public enum ProviderAssembly {
    public static func register() {
        DIContainer.register(type: NetworkProvider.self) {
            NetworkProviderImpl()
        }
        DIContainer.register(
            type: SocialCredentialProvider.self,
            name: "kakao"
        ) {
            KakaoCredentialProvider()
        }
        DIContainer.register(
            type: SocialCredentialProvider.self,
            name: "apple"
        ) {
            AppleCredentialProvider()
        }
        DIContainer.register(type: Interceptor.self, name: "tokenInterceptor") {
            TokenInterceptor()
        }

        DIContainer.register(type: Interceptor.self, name: "authInterceptor") {
            AuthInterceptor(tokenRepository: DIContainer.resolve(type: TokenRepository.self), authRepository: { DIContainer.resolve(type: AuthAPIRepository.self) })
        }
    }
}
