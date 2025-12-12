import DomainInterface
import NotificationCenter

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
    private let fetchAppleCredentialUseCase: FetchSocialCredentialUseCase
    private let fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase
    private let loginWithAppleUseCase: LoginWithAppleUseCase
    private let loginWithKakaoUseCase: LoginWithKakaoUseCase
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    private let putFCMTokenUseCase: PutFCMTokenUseCase
    private let fetchPlatformUseCase: FetchPlatformUseCase

    // MARK: - init
    public init(
        fetchAppleCredentialUseCase: FetchSocialCredentialUseCase,
        fetchKakaoCredentialUseCase: FetchSocialCredentialUseCase,
        loginWithAppleUseCase: LoginWithAppleUseCase,
        loginWithKakaoUseCase: LoginWithKakaoUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase,
        putFCMTokenUseCase: PutFCMTokenUseCase,
        fetchPlatformUseCase: FetchPlatformUseCase
    ) {
        self.fetchAppleCredentialUseCase = fetchAppleCredentialUseCase
        self.fetchKakaoCredentialUseCase = fetchKakaoCredentialUseCase
        self.loginWithAppleUseCase = loginWithAppleUseCase
        self.loginWithKakaoUseCase = loginWithKakaoUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
        self.putFCMTokenUseCase = putFCMTokenUseCase
        self.fetchPlatformUseCase = fetchPlatformUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchPlatformUseCase.execute()
                .map { Mutation.setRelogin($0) }
        case .kakaoLoginButtonTapped:
            return handleKakaoLogin()
        case .appleLoginButtonTapped:
            return handleAppleLogin()
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
    func handleKakaoLogin() -> Observable<Mutation> {
        return checkNotificationPermissionAndFetchFCMToken()
            .withUnretained(self)
            .flatMap { owner, fcmToken in
                // 1. 카카오 로그인 자격 증명 가져오기
                owner.fetchKakaoCredentialUseCase.execute()
                    .flatMap { credential in
                        // 2. 자격 증명을 바탕으로 로그인 요청
                        owner.loginWithKakaoUseCase.execute(credential: credential)
                            .flatMap { response -> Observable<Mutation> in
                                if response.isRegister {
                                    // 3. 회원가입된 유저면 FCM 토큰 등록 후 홈으로 이동
                                    return owner.putFCMTokenUseCase.execute(fcmToken: fcmToken)
                                        .andThen(.just(.navigateTo(route: .home)))
                                } else {
                                    // 4. 미가입 유저면 약관 동의 화면으로 이동
                                    return .just(.navigateTo(route: .termsAgreements(
                                        credential: credential,
                                        platform: .kakao
                                    )))
                                }
                            }
                            .catch { error in
                                // 5. 로그인 실패 예외 처리
                                if case AuthError.userNotFound = error {
                                    return .just(.navigateTo(route: .termsAgreements(
                                        credential: credential,
                                        platform: .kakao
                                    )))
                                } else {
                                    return .just(.navigateTo(route: .error))
                                }
                            }
                    }
            }
    }

    func handleAppleLogin() -> Observable<Mutation> {
        return checkNotificationPermissionAndFetchFCMToken()
            .withUnretained(self)
            .flatMap { owner, fcmToken in
                // 1. 애플 로그인 자격 증명 가져오기
                owner.fetchAppleCredentialUseCase.execute()
                    .flatMap { credential in
                        // 2. 자격 증명을 바탕으로 로그인 요청
                        owner.loginWithAppleUseCase.execute(credential: credential)
                            .flatMap { response -> Observable<Mutation> in
                                if response.isRegister {
                                    // 3. 회원가입된 유저면 FCM 토큰 등록 후 홈으로 이동
                                    return owner.putFCMTokenUseCase.execute(fcmToken: fcmToken)
                                        .andThen(.just(.navigateTo(route: .home)))
                                } else {
                                    // 4. 미가입 유저면 약관 동의 화면으로 이동
                                    return .just(.navigateTo(route: .termsAgreements(
                                        credential: credential,
                                        platform: .apple
                                    )))
                                }
                            }
                            .catch { error in
                                // 5. 로그인 실패 예외 처리
                                if case AuthError.userNotFound = error {
                                    return .just(.navigateTo(route: .termsAgreements(
                                        credential: credential,
                                        platform: .apple
                                    )))
                                } else {
                                    return .just(.navigateTo(route: .error))
                                }
                            }
                    }
            }
    }

    func checkNotificationPermissionAndFetchFCMToken() -> Observable<String?> {
        return Observable.create { [weak self] observer in
            guard let self else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }

            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    let result = self.fetchTokenUseCase.execute(type: .fcmToken)
                    switch result {
                    case .success(let token): observer.onNext(token)
                    case .failure: observer.onNext(nil)
                    }
                default:
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
