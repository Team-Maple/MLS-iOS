import ReactorKit
import RxSwift

public final class MonsterFilterBottomSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithLevelRange(start: Int, end: Int)
        case clear
    }

    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case applyButtonTapped(start: Int, end: Int)
        case clearButtonTapped
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
    public init(startLevel: Int = 1, endLevel: Int = 200) {
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case let .applyButtonTapped(start, end):
            guard start <= end else {
                return .empty()
            }

            return .just(.navigateTo(route: .dismissWithLevelRange(start: start, end: end)))
        case .clearButtonTapped:
            return .just(.navigateTo(route: .clear))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            switch route {
            case .dismiss:
                newState.route = route
            case .dismissWithLevelRange:
                newState.route = route
            default:
                newState.route = route
            }
        }

        return newState
    }
}
