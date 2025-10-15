import DomainInterface
import NotificationCenter

import ReactorKit
import RxSwift

public final class TermsAgreementReactor: Reactor {
    // MARK: - Type
    public enum AgreeType {
        case total, age, serviceTerms, personalInfo, marketing
    }

    public enum Route {
        case none
        case dismiss
        case onBoarding
        case error
        case ageAgreement
        case serviceAgreement
        case personalAgreement
        case marketingAgreement
    }

    // MARK: - Reactor
    public enum Action {
        case backButtonTapped
        case toggleAgree(type: AgreeType)
        case bottomButtonTapped
        case navigateTo(route: Route)
    }

    public enum Mutation {
        case setAgreeState(type: AgreeType, isOn: Bool)
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none

        var isTotalAgree: Bool = false
        var isAgeAgree: Bool = false
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
    private let fetchTokenUseCase: FetchTokenFromLocalUseCase
    private let updateMarketingAgreementUseCase: UpdateMarketingAgreementUseCase

    // MARK: - init
    public init(
        credential: Credential,
        socialPlatform: LoginPlatform,
        signUpWithKakaoUseCase: SignUpWithKakaoUseCase,
        signUpWithAppleUseCase: SignUpWithAppleUseCase,
        saveTokenUseCase: SaveTokenToLocalUseCase,
        fetchTokenUseCase: FetchTokenFromLocalUseCase,
        updateMarketingAgreementUseCase: UpdateMarketingAgreementUseCase
    ) {
        self.credential = credential
        self.socialPlatform = socialPlatform
        self.signUpWithKakaoUseCase = signUpWithKakaoUseCase
        self.signUpWithAppleUseCase = signUpWithAppleUseCase
        self.saveTokenUseCase = saveTokenUseCase
        self.fetchTokenUseCase = fetchTokenUseCase
        self.updateMarketingAgreementUseCase = updateMarketingAgreementUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(route: .dismiss))
        case .toggleAgree(let type):
            let isOn: Bool
            switch type {
            case .total:
                isOn = !currentState.isTotalAgree
            case .age:
                isOn = !currentState.isAgeAgree
            case .serviceTerms:
                isOn = !currentState.isServiceTermsAgree
            case .personalInfo:
                isOn = !currentState.isPersonalInformationAgree
            case .marketing:
                isOn = !currentState.isMarketingAgree
            }
            return .just(.setAgreeState(type: type, isOn: isOn))
        case .bottomButtonTapped:
            var fcmToken: String?

            UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                guard let self else { return }
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    if case .success(let token) = fetchTokenUseCase.execute(type: .fcmToken) {
                        fcmToken = token
                    }
                default:
                    fcmToken = nil
                }
            }

            switch socialPlatform {
            case .kakao:
                return signUpWithKakaoUseCase.execute(credential: credential, isMarketingAgreement: currentState.isMarketingAgree, fcmToken: fcmToken)
                    .withUnretained(self)
                    .map { owner, response in
                        let accessTokenResult = owner.saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                        let refreshTokenResult = owner.saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)
                        let isTokenSaveSuccess = owner.isTokenSaveSuccess(access: accessTokenResult, refresh: refreshTokenResult)
                        return isTokenSaveSuccess ? .navigateTo(route: .onBoarding) : .navigateTo(route: .error)
                    }
                    .catchAndReturn(.navigateTo(route: .error))
            case .apple:
                return signUpWithAppleUseCase.execute(credential: credential, isMarketingAgreement: currentState.isMarketingAgree, fcmToken: fcmToken)
                    .withUnretained(self)
                    .map { owner, response in
                        let accessTokenResult = owner.saveTokenUseCase.execute(type: .accessToken, value: response.accessToken)
                        let refreshTokenResult = owner.saveTokenUseCase.execute(type: .refreshToken, value: response.refreshToken)
                        let isTokenSaveSuccess = owner.isTokenSaveSuccess(access: accessTokenResult, refresh: refreshTokenResult)
                        return isTokenSaveSuccess ? .navigateTo(route: .onBoarding) : .navigateTo(route: .error)
                    }
                    .catchAndReturn(.navigateTo(route: .error))
            }

        case .navigateTo(let route):
            return .just(.navigateTo(route: route))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setAgreeState(let type, let isOn):
            switch type {
            case .total:
                newState.isTotalAgree = isOn
                newState.isAgeAgree = isOn
                newState.isServiceTermsAgree = isOn
                newState.isPersonalInformationAgree = isOn
                newState.isMarketingAgree = isOn
            case .age:
                newState.isAgeAgree = isOn
            case .serviceTerms:
                newState.isServiceTermsAgree = isOn
            case .personalInfo:
                newState.isPersonalInformationAgree = isOn
            case .marketing:
                newState.isMarketingAgree = isOn
            }
        case .navigateTo(let route):
            newState.route = route
        }

        // bottomButton 활성화 체크
        let allRequiredAgreed = newState.isAgeAgree && newState.isServiceTermsAgree && newState.isPersonalInformationAgree
        newState.bottomButtonIsEnabled = allRequiredAgreed
        newState.isTotalAgree = allRequiredAgreed && newState.isMarketingAgree

        return newState
    }

    private func isTokenSaveSuccess(access: Result<Void, Error>, refresh: Result<Void, Error>) -> Bool {
        if case .success = access, case .success = refresh {
            return true
        }
        return false
    }
}
