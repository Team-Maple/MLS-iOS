import ReactorKit
internal import RxSwift
internal import RxCocoa

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
        case setState
    }
    
    public struct State {
        var isTotalAgree: Bool = false
        var isOldAgree: Bool = false
        var isServiceTermsAgree: Bool = false
        var isPersonalInformationAgree: Bool = false
        var isMarketingAgree: Bool = false
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
            return Observable.just(.setState)
        case .totalAgreeButtonTapped:
            print("Tapped")
            return Observable.just(.setState)
        case .oldAgreeButtonTapped:
            print("Tapped")
            return Observable.just(.setState)
        case .serviceTermsAgreeButtonTapped:
            print("Tapped")
            return Observable.just(.setState)
        case .personalInformationAgreeButtonTapped:
            print("Tapped")
            return Observable.just(.setState)
        case .marketingAgreeButtonTapped:
            print("Tapped")
            return Observable.just(.setState)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setState:
            return newState
        }
        
        return newState
    }
}
