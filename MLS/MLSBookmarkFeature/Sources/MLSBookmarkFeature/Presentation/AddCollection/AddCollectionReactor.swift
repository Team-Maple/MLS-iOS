import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class AddCollectionReactor: Reactor {
    enum Route {
        case dismiss
        case dismissWithData
        case createError
        case updateError
    }

    enum Action {
        case inputTextChanged(String?)
        case backButtonTapped
        case completeButtonTapped
    }

    enum Mutation {
        case saveInput(String)
        case setError(Bool)
        case setButtonEnabled(Bool)
        case toNavigate(Route)
    }

    struct State {
        @Pulse var route: Route?
        var collection: CollectionResponse?
        var inputText: String?
        var isError: Bool = false
        var isButtonEnabled: Bool = false
    }

    var initialState: State
    private let collectionRepository: CollectionRepository

    init(collection: CollectionResponse?, collectionRepository: CollectionRepository) {
        self.initialState = State(collection: collection, inputText: collection?.name)
        self.collectionRepository = collectionRepository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .inputTextChanged(let text):
            let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return Observable.from([.setButtonEnabled(!trimmed.isEmpty), .saveInput(trimmed)])

        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))

        case .completeButtonTapped:
            guard let text = currentState.inputText else { return .empty() }
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 18 {
                return .just(.setError(true))
            }
            if currentState.collection == nil {
                return collectionRepository.createCollectionList(name: trimmed)
                    .andThen(.just(.toNavigate(.dismissWithData)))
                    .catch { _ in .just(.toNavigate(.createError)) }
            } else {
                guard let id = currentState.collection?.collectionId else { return .empty() }
                return collectionRepository.updateCollectionName(collectionId: id, name: trimmed)
                    .andThen(.just(.toNavigate(.dismissWithData)))
                    .catch { _ in .just(.toNavigate(.updateError)) }
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .saveInput(let text): newState.inputText = text
        case .setError(let isError): newState.isError = isError
        case .setButtonEnabled(let isEnabled): newState.isButtonEnabled = isEnabled
        case .toNavigate(let route): newState.route = route
        }
        return newState
    }
}
