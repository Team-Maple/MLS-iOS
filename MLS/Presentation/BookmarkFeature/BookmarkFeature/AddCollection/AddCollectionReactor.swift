import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class AddCollectionModalReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case dismiss
        case dismissWithData
        case createError
        case updateError
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
        case setButtonEnabled(Bool)
        case toNavigate(Route)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        var collection: CollectionResponse?
        var inputText: String?
        var isError: Bool = false
        var isButtonEnabled: Bool = false
    }

    // MARK: - Properties
    public var initialState = State(collection: nil)

    private let createCollectionListUseCase: CreateCollectionListUseCase
    private let setCollectionUseCase: UpdateCollectionUseCase

    // MARK: - Init
    public init(collection: CollectionResponse?, createCollectionListUseCase: CreateCollectionListUseCase, setCollectionUseCase: UpdateCollectionUseCase) {
        self.initialState = State(collection: collection, inputText: collection?.name)
        self.createCollectionListUseCase = createCollectionListUseCase
        self.setCollectionUseCase = setCollectionUseCase
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
            guard let text = currentState.inputText else { return .empty() }
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmed.count > 18 {
                return .just(.setError(true))
            }

            if currentState.collection == nil {
                return createCollectionListUseCase.execute(name: trimmed)
                    .andThen(.just(.toNavigate(.dismissWithData)))
                    .catch { _ in
                        return .just(.toNavigate(.createError))
                    }
            } else {
                guard let id = currentState.collection?.collectionId else { return .empty() }
                return setCollectionUseCase.execute(
                    collectionId: id,
                    name: trimmed
                )
                .andThen(.just(.toNavigate(.dismissWithData)))
                .catch { _ in
                    return .just(.toNavigate(.updateError))
                }
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
        }

        return newState
    }
}
