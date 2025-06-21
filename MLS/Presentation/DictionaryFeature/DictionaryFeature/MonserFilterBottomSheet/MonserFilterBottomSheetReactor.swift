import ReactorKit
import RxSwift
import RxCocoa

final public class MonserFilterBottomSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }
    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
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
    
    // MARK: - init
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
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
