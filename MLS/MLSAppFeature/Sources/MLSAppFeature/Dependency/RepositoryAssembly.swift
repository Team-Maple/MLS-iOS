import MLSAppFeatureInterface
import MLSAuthFeature
import MLSAuthFeatureInterface
import MLSBookmarkFeature
import MLSBookmarkFeatureInterface
import MLSCore
import MLSDictionaryFeature
import MLSDictionaryFeatureInterface
import MLSMyPageFeature
import MLSMyPageFeatureInterface
import MLSRecommendationFeature
import MLSRecommendationFeatureInterface

public enum RepositoryAssembly {
    public static func register() {
        DIContainer.register(type: TokenRepository.self) {
            KeyChainRepositoryImpl()
        }
        DIContainer.register(type: AuthAPIRepository.self) {
            AuthAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor"),
                authInterceptor: DIContainer.resolve(type: Interceptor.self, name: "authInterceptor")
            )
        }
        DIContainer.register(type: DictionaryDetailAPIRepository.self) {
            DictionaryDetailAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: DictionaryListAPIRepository.self) {
            DictionaryListAPIRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                tokenInterceptor: DIContainer.resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: BookmarkRepository.self) {
            BookmarkRepositoryImpl()
        }
        DIContainer.register(type: MLSAuthFeatureInterface.UserDefaultsRepository.self, name: "authUserDefaultsRepository") {
            MLSAuthFeature.UserDefaultsRepositoryImpl()
        }
        DIContainer.register(type: MLSDictionaryFeatureInterface.UserDefaultsRepository.self, name: "dictionaryUserDefaultsRepository") {
            MLSDictionaryFeature.UserDefaultsRepositoryImpl()
        }
        DIContainer.register(type: AlarmRepository.self) {
            AlarmRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                interceptor: DIContainer
                    .resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: CollectionRepository.self) {
            CollectionRepositoryImpl()
        }
        DIContainer.register(type: RecommendationRepository.self) {
            RecommendationRepositoryImpl()
        }
        DIContainer.register(type: RecentSearchRepository.self) {
            RecentSearchRepositoryImpl()
        }
        DIContainer.register(type: NotificationPermissionRepository.self) {
            NotificationPermissionRepositoryImpl()
        }
        DIContainer.register(type: MyPageRepository.self) {
            MyPageRepositoryImpl(
                provider: DIContainer.resolve(type: NetworkProvider.self),
                interceptor: DIContainer
                    .resolve(type: Interceptor.self, name: "tokenInterceptor")
            )
        }
        DIContainer.register(type: BookmarkAuthRepository.self) {
            BookmarkAuthRepositoryImpl(
                tokenRepository: DIContainer
                    .resolve(type: TokenRepository.self),
                authAPIRepository: DIContainer
                    .resolve(type: AuthAPIRepository.self)
            )
        }
        DIContainer.register(type: BookmarkUserDefaultsRepository.self) {
            BookmarkUserDefaultsRepositoryImpl()
        }
        DIContainer.register(type: AppStoreRepositoryProtocol.self) {
            AppStoreRepository()
        }
        DIContainer.register(type: UpdateSkipRepositoryProtocol.self) {
            UpdateSkipRepository()
        }
     }
}
