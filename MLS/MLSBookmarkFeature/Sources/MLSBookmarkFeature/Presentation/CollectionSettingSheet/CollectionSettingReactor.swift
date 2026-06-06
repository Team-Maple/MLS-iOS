import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class CollectionSettingReactor: Reactor {
    enum Route {
        case none
        case dismiss
        case dismissWithMenu(CollectionSettingMenu)
    }

    enum Action {
        case cancelButtonTapped
        case editBookmarkButtonTapped
        case editNameButtonTapped
        case deleteButtonTapped
    }

    enum Mutation {
        case navigateTo(Route)
    }

    struct State {
        @Pulse var route: Route = .none
        var menu = CollectionSettingMenu.allCases
    }

    var initialState: State

    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .editBookmarkButtonTapped:
            return .just(.navigateTo(.dismissWithMenu(.editBookmark)))
        case .editNameButtonTapped:
            return .just(.navigateTo(.dismissWithMenu(.editName)))
        case .deleteButtonTapped:
            return .just(.navigateTo(.dismissWithMenu(.delete)))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
