import UIKit

import BookmarkFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class CollectionSettingReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithMenu(CollectionSettingMenu)
    }

    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case editBookmarkButtonTapped
        case editNameButtonTapped
        case deleteButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none
        var menu = CollectionSettingMenu.allCases
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
        case .editBookmarkButtonTapped:
            return Observable.just(.navigateTo(route: .dismissWithMenu(.editBookmark)))
        case .editNameButtonTapped:
            return Observable.just(.navigateTo(route: .dismissWithMenu(.editName)))
        case .deleteButtonTapped:
            return Observable.just(.navigateTo(route: .dismissWithMenu(.delete)))
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
