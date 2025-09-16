import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class SelectImageReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithSave
    }

    // MARK: - Reactor
    public enum Action {
        case cancelButtonTapped
        case sortedButtonTapped
        case applyButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none
        var images: [MapleIllustration] = [
            .mushroom,
            .slime,
            .blueSnail,
            .juniorYeti,
            .yeti,
            .pepe,
            .wraith,
            .starPixie,
            .rash
        ]
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
        case .sortedButtonTapped:
            return .empty()
        case .applyButtonTapped:
            return Observable.just(.navigateTo(route: .dismissWithSave))
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
