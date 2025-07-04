import DomainInterface

import ReactorKit
import RxSwift

public final class TermsAgreementReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case onBoarding
        case error
    }

    // MARK: - Reactor
    public enum Action {
        case backButtonTapped
        case totalAgreeButtonTapped
        case oldAgreeButtonTapped
        case serviceTermsAgreeButtonTapped
        case personalInformationAgreeButtonTapped
        case marketingAgreeButtonTapped
        case bottomButtonTapped
    }

    public enum Mutation {
        case changeIsTotalAgreeState
        case changeIsOldAgreeState
        case changeIsServiceTermsAgreeState
        case changeIsPersonalInformationAgreeState
        case changeIsMarketingAgreeState
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none

        var isTotalAgree: Bool = false
        var isOldAgree: Bool = false
        var isServiceTermsAgree: Bool = false
        var isPersonalInformationAgree: Bool = false
        var isMarketingAgree: Bool = false
        var bottomButtonIsEnabled: Bool = false
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
    private let credential: Credential
    private let socialPlatform: LoginPlatform
    private let signUpWithKakaoUseCase: SignUpWithKakaoUseCase
    private let signUpWithAppleUseCase: SignUpWithAppleUseCase
    private let saveTokenUseCase: SaveTokenToLocalUseCase

    // MARK: - init
    public init(
        credential: Credential,
        socialPlatform: LoginPlatform,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        saveTokenUseCase: SaveTokenToLocalUseCase
    ) {
        self.credential = credential
        self.socialPlatform = socialPlatform
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.saveTokenUseCase = saveTokenUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .totalAgreeButtonTapped:
            return Observable.just(.changeIsTotalAgreeState)
        case .oldAgreeButtonTapped:
            return Observable.just(.changeIsOldAgreeState)
        case .serviceTermsAgreeButtonTapped:
            return Observable.just(.changeIsServiceTermsAgreeState)
        case .personalInformationAgreeButtonTapped:
            return Observable.just(.changeIsPersonalInformationAgreeState)
        case .marketingAgreeButtonTapped:
            return Observable.just(.changeIsMarketingAgreeState)
        case .bottomButtonTapped:
            switch socialPlatform {
            case .kakao:
                return signUpWithKakaoUseCase.execute(credential: credential, isMarketingAgreement: currentState.isMarketingAgree)
                    .withUnretained(self)
                    .map { (owner, response) in
                        let accessTokenResult = owner.saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                        let refreshTokenResult = owner.saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)
                        let isTokenSaveSuccess = owner.isTokenSaveSuccess(access: accessTokenResult, refresh: refreshTokenResult)
                        return isTokenSaveSuccess ? .navigateTo(route: .onBoarding) : .navigateTo(route: .error)
                    }
                    .catchAndReturn(.navigateTo(route: .error))
            case .apple:
                return signUpWithAppleUseCase.execute(credential: credential, isMarketingAgreement: currentState.isMarketingAgree)
                    .withUnretained(self)
                    .map { (owner, response) in
                        let accessTokenResult = owner.saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                        let refreshTokenResult = owner.saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)
                        let isTokenSaveSuccess = owner.isTokenSaveSuccess(access: accessTokenResult, refresh: refreshTokenResult)
                        return isTokenSaveSuccess ? .navigateTo(route: .onBoarding) : .navigateTo(route: .error)
                    }
                    .catchAndReturn(.navigateTo(route: .error))
            }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .changeIsTotalAgreeState:
            newState.isOldAgree = newState.isTotalAgree ? false : true
            newState.isServiceTermsAgree = newState.isTotalAgree ? false : true
            newState.isPersonalInformationAgree = newState.isTotalAgree ? false : true
            newState.isMarketingAgree = newState.isTotalAgree ? false : true
            newState.isTotalAgree.toggle()
        case .changeIsOldAgreeState:
            newState.isOldAgree.toggle()
        case .changeIsServiceTermsAgreeState:
            newState.isServiceTermsAgree.toggle()
        case .changeIsPersonalInformationAgreeState:
            newState.isPersonalInformationAgree.toggle()
        case .changeIsMarketingAgreeState:
            newState.isMarketingAgree.toggle()
        case .navigateTo(let route):
            newState.route = route
        }
        if newState.isOldAgree == true &&
            newState.isServiceTermsAgree == true &&
            newState.isPersonalInformationAgree == true {
            if newState.isMarketingAgree == true {
                newState.isTotalAgree = true
            } else {
                newState.isTotalAgree = false
            }
            newState.bottomButtonIsEnabled = true
        } else {
            newState.bottomButtonIsEnabled = false
            newState.isTotalAgree = false
        }
        return newState
    }

    private func isTokenSaveSuccess(access: Result<Void, Error>, refresh: Result<Void, Error>) -> Bool {
        if case .success = access, case .success = refresh {
            return true
        }
        return false
    }
}
