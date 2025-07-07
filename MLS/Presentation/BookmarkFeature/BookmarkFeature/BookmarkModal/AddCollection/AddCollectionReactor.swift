import DesignSystem
import DomainInterface

import ReactorKit
import RxSwift

public final class AddCollectionReactor: Reactor {
    
    // MARK: - Route
    public enum Route {
        case none
        case dismiss
    }

    // MARK: - Action
    public enum Action {
        case backButtonTapped
        case completeButtonTapped(String)
        case inputText(String?)
    }

    // MARK: - Mutation
    public enum Mutation {
        case setRoute(Route)
        case setError(Bool)
        case setButtonEnabled(Bool)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route = .none
        var isError: Bool = false
        var isButtonEnabled: Bool = false
    }

    public let initialState = State()

    // MARK: - mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.setRoute(.dismiss))

        case .completeButtonTapped(let text):
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let isTooLong = trimmed.count > 18

            return .just(isTooLong ? .setError(true) : .setRoute(.dismiss))

        case .inputText(let text):
            let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let isError = trimmed.count > 18

            return .just(.setError(isError))
        }
    }

    // MARK: - reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setRoute(let route):
            newState.route = route

        case .setError(let isError):
            newState.isError = isError

        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
        }

        return newState
    }
}
