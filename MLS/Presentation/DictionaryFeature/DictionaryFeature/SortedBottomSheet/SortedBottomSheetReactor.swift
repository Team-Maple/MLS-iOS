import ReactorKit
import RxSwift
import RxCocoa

final public class SortedBottomSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }
    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case sortedButtonTapped(index: Int)
    }
    
    public enum Mutation {
        case navigateTo(route: Route)
        case setSelectedIndex(index: Int)
    }
    
    public struct State {
        var sortedOptions: [String]
        var selectedIndex: Int
        @Pulse var route: Route = .none
    }
    
    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
    
    // MARK: - init
    public init(sortedOptions: [String], selectedIndex: Int) {
        self.initialState = State(sortedOptions: sortedOptions, selectedIndex: selectedIndex)
    }
    
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .sortedButtonTapped(let index):
            return Observable.just(.setSelectedIndex(index: index))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setSelectedIndex(let index):
            newState.selectedIndex = index
        }
        
        return newState
    }
}
