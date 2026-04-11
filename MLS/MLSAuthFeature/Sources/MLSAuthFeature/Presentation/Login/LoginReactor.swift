import MLSAuthFeatureInterface

import ReactorKit
import RxSwift

public final class LoginReactor: Reactor {
    public enum Route {
        case none
        case termsAgreements(credential: Credential, platform: LoginPlatform)
        case error
        case home
        case dismiss
    }

    // MARK: - Reactor
    public enum Action {
        case viewWillAppear
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case guestLoginButtonTapped
        case backButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setRelogin(LoginPlatform?)
    }

    public struct State {
        @Pulse var route: Route = .none
        var platform: LoginPlatform?
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
    private let appleProvider: SocialCredentialProvider
    private let kakaoProvider: SocialCredentialProvider
    private let socialLoginUseCase: SocialLoginUseCase
    private let userDefaultsRepository: UserDefaultsRepository

    // MARK: - init
    public init(
        appleProvider: SocialCredentialProvider,
        kakaoProvider: SocialCredentialProvider,
        socialLoginUseCase: SocialLoginUseCase,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.appleProvider = appleProvider
        self.kakaoProvider = kakaoProvider
        self.socialLoginUseCase = socialLoginUseCase
        self.userDefaultsRepository = userDefaultsRepository
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return userDefaultsRepository.fetchPlatform()
                .map { Mutation.setRelogin($0) }
        case .kakaoLoginButtonTapped:
            return handleLogin(provider: kakaoProvider, platform: .kakao)
        case .appleLoginButtonTapped:
            return handleLogin(provider: appleProvider, platform: .apple)
        case .guestLoginButtonTapped:
            return .just(.navigateTo(route: .home))
        case .backButtonTapped:
            return .just(.navigateTo(route: .dismiss))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setRelogin(let platform):
            newState.platform = platform
        }
        return newState
    }
}

// MARK: - Methods
private extension LoginReactor {
    func handleLogin(provider: SocialCredentialProvider, platform: LoginPlatform) -> Observable<Mutation> {
        return provider.getCredential()
            .flatMap { [weak self] credential -> Observable<Mutation> in
                guard let self else { return .empty() }
                return self.socialLoginUseCase.execute(credential: credential, platform: platform)
                    .map { response -> Mutation in
                        if response.isRegister {
                            return .navigateTo(route: .home)
                        } else {
                            return .navigateTo(route: .termsAgreements(credential: credential, platform: platform))
                        }
                    }
                    .catch { error in
                        if case AuthError.userNotFound = error {
                            return .just(.navigateTo(route: .termsAgreements(credential: credential, platform: platform)))
                        }
                        return .just(.navigateTo(route: .error))
                    }
            }
    }
}
