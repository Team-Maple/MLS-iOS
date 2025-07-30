import BookmarkFeatureInterface

import ReactorKit

public final class AddCollectionModalReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case dismiss
        case dismissWithSuccess(BookmarkCollection?)
    }

    // MARK: - Action
    public enum Action {
        case inputTextChanged(String?)
        case backButtonTapped
        case completeButtonTapped
    }

    // MARK: - Mutation
    public enum Mutation {
        case saveInput(String)
        case setError(Bool)
        case addCollection(String)
        case setButtonEnabled(Bool)
        case toNavigate(Route)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        var collection: BookmarkCollection?
        var inputText: String = ""
        var isError: Bool = false
        var isButtonEnabled: Bool = false
    }

    // MARK: - Properties
    public let initialState: State

    // MARK: - Init
    public init(collection: BookmarkCollection?) {
        self.initialState = State(collection: collection)
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputTextChanged(let text):
            let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return Observable.from([
                .setButtonEnabled(!trimmed.isEmpty),
                .saveInput(trimmed)
            ])

        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))

        case .completeButtonTapped:
            let trimmed = currentState.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 18 {
                return .just(.setError(true))
            } else {
                return .just(.addCollection(trimmed))
            }
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .saveInput(let text):
            newState.inputText = text
        case .setError(let isError):
            newState.isError = isError
        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
        case .toNavigate(let route):
            newState.route = route
        case .addCollection(let title):
            var collection = newState.collection
            collection?.title = title
            newState.route = .dismissWithSuccess(collection)
        }

        return newState
    }
}
