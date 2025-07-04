import os

import Core
import DomainInterface

import ReactorKit
import RxSwift

public final class LoginReactor: Reactor {
    public enum Route {
        case none
        case termsAgreements(credential: Credential, platform: LoginPlatform)
        case home
        case error
    }

    // MARK: - Reactor
    public enum Action {
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case guestLoginButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
    private let fetchAppleCredentialUseCase: FetchSocialCredentialUseCase
    private let fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase

    // MARK: - init
    public init(
        fetchAppleCredentialUseCase: FetchSocialCredentialUseCase,
        fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase
    ) {
        self.fetchAppleCredentialUseCase = fetchAppleCredentialUseCase
        self.fetchKakaoCredentialUseCase = fetchKakaoCredentialUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginButtonTapped:
            return fetchKakaoCredentialUseCase.execute()
                .withUnretained(self)
                .flatMap { owner, credential in
                    owner.loginWithKakaoUseCase.execute(credential: credential)
                        .map { (response: $0, credential: credential) }
                        .map { result in
                            result.response.isRegister
                                ? .navigateTo(route: .home)
                                : .navigateTo(route: .termsAgreements(credential: result.credential, platform: .kakao))
                        }
                        .catch { error in
                            if case AuthError.userNotFound = error {
                                return Observable.just(.navigateTo(route: .termsAgreements(credential: credential, platform: .kakao)))
                            } else {
                                return Observable.just(.navigateTo(route: .error))
                            }
                        }
                }
        case .appleLoginButtonTapped:
            return fetchAppleCredentialUseCase.execute()
                .withUnretained(self)
                .flatMap { owner, credential in
                    owner.loginWithAppleUseCase.execute(credential: credential)
                        .map { (response: $0, credential: credential) }
                        .map { result in
                            result.response.isRegister
                                ? .navigateTo(route: .home)
                                : .navigateTo(route: .termsAgreements(credential: result.credential, platform: .apple))
                        }
                        .catch { error in
                            if case AuthError.userNotFound = error {
                                return Observable.just(.navigateTo(route: .termsAgreements(credential: credential, platform: .apple)))
                            } else {
                                return Observable.just(.navigateTo(route: .error))
                            }
                        }
                }
        case .guestLoginButtonTapped:
            return Observable.just(.navigateTo(route: .home))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
