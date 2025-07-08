import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissModal
    }

    public enum Action {
        case backButtonTapped
        case modalBackButtonTapped
        case inputTextChanged(String?)
        case completeButtonTapped
    }

    public enum Mutation {
        case setError(Bool)
        case setButtonEnabled(Bool)
        case addCollection
        case toNavigate(Route)
        case saveInput(String)
    }

    public struct State {
        @Pulse var route: Route
        var collections = ["1", "2", "3"]
        var isError: Bool = false
        var isButtonEnabled: Bool = false
        var currentInput: String = ""
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State(route: .none)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))
        case .inputTextChanged(let text):
            let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return Observable.from([
                .setButtonEnabled(!trimmed.isEmpty),
                .saveInput(trimmed)
            ])
        case .completeButtonTapped:
            let trimmed = currentState.currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 18 {
                return .just(.setError(true))
            } else {
                // 저장
                return .just(.addCollection)
            }
        case .modalBackButtonTapped:
            return .just(.toNavigate(.dismissModal))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setError(let value):
            newState.isError = value
        case .setButtonEnabled(let value):
            newState.isButtonEnabled = value
        case .addCollection:
            newState.route = .dismissModal
        case .toNavigate(let route):
            newState.route = route
        case .saveInput(let input):
            newState.currentInput = input
        }
        return newState
    }
}
