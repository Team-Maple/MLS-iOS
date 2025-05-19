import ReactorKit
internal import RxSwift

public final class TermsAgreementReactor: Reactor {
    
    // MARK: - Reactor
    public enum Action {
        case backButtonTapped
        case totalAgreeButtonTapped
        case oldAgreeButtonTapped
        case serviceTermsAgreeButtonTapped
        case personalInformationAgreeButtonTapped
        case marketingAgreeButtonTapped
    }
    
    public enum Mutation {
        case temp
        case changeIsTotalAgreeState
        case changeIsOldAgreeState
        case changeIsServiceTermsAgreeState
        case changeIsPersonalInformationAgreeState
        case changeIsMarketingAgreeState
    }
    
    public struct State {
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
            return Observable.just(.temp)
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
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .temp:
            return newState
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
        }
        if newState.isOldAgree == true
            && newState.isServiceTermsAgree == true
            && newState.isPersonalInformationAgree == true
        {
            newState.bottomButtonIsEnabled = true
            if newState.isMarketingAgree == true {
                newState.isTotalAgree = true
            }
        } else {
            newState.bottomButtonIsEnabled = false
            newState.isTotalAgree = false
        }
        return newState
    }
}
