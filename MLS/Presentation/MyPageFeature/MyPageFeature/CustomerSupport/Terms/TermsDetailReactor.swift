import DomainInterface

import ReactorKit

public final class TermsDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
    }

    public enum Action {

    }

    public enum Mutation {

    }

    public struct State {

    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = .init()
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        return newState
    }
}
