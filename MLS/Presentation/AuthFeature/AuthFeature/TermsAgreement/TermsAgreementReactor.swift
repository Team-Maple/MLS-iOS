import ReactorKit
internal import RxSwift

public final class TermsAgreementReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case onBoarding
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
        case moveToRecentScene
        case moveToOnBoarding
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

    // MARK: - init
    public init() {
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.moveToRecentScene)
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
            return Observable.just(.moveToOnBoarding)
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
        case .moveToRecentScene:
            newState.route = .dismiss
        case .moveToOnBoarding:
            newState.route = .onBoarding
        }
        if newState.isOldAgree == true && newState.isServiceTermsAgree == true && newState.isPersonalInformationAgree == true && newState.isMarketingAgree == true {
            newState.bottomButtonIsEnabled = true
            newState.isTotalAgree = true
        } else {
            newState.bottomButtonIsEnabled = false
            newState.isTotalAgree = false
        }
        return newState
    }
}
