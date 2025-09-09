import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class SortedBottomSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithSave
    }

    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case sortedButtonTapped(index: Int)
        case applyButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setSelectedIndex(index: Int)
    }

    public struct State {
        var sortTypes: [SortType]
        var selectedIndex: Int
        var isTabbarHidden: Bool
        @Pulse var route: Route = .none
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(sortTypes: [SortType], selectedIndex: Int, isTabbarHidden: Bool = false) {
        self.initialState = State(sortTypes: sortTypes, selectedIndex: selectedIndex, isTabbarHidden: isTabbarHidden)
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .sortedButtonTapped(let index):
            return Observable.just(.setSelectedIndex(index: index))
        case .applyButtonTapped:
            return Observable.just(.navigateTo(route: .dismissWithSave))
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
