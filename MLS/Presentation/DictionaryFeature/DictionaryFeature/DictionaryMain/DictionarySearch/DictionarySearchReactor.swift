import ReactorKit

import DomainInterface

public final class DictionarySearchReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case search
    }

    public enum Action {
        case backButtonTapped
        case searchButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
    }

    public struct State {
        @Pulse var route: Route
        let recentResult: [String]
        var hasRecent: Bool {
            !recentResult.isEmpty
        }

        let popularResult: [String]
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init() {
        self.initialState = State(
            route: .none,
            recentResult: ["망치", "도끼", "창", "드라이버", "몽키스패너"],
            popularResult: [
                "주니어 예티",
                "주니어 페페",
                "주니어 네키",
                "주니어 버섯",
                "주니어 달팽이",
                "주니어 유림",
                "주니어 채령",
                "주니어 진훈",
                "주니어 준영",
                "주니어 명범",
                "주니어 진혁"
            ]
        )
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
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
