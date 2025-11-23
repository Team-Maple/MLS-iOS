import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case addCollection
    }

    public enum Action {
        case backButtonTapped
        case addCollectionTapped
        case selectItem(Int)
    }

    public enum Mutation {
        case toNavigate(Route)
        case checkCollection([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var collections = [CollectionResponse]()
        var selectedItems = [CollectionResponse]()
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
        case .addCollectionTapped:
            return .just(.toNavigate(.addCollection))
        case .selectItem(let id):
            var newItems = currentState.selectedItems
            if let index = newItems.firstIndex(where: { $0.collectionId == id }) {
                newItems.remove(at: index)
            } else if let collection = currentState.collections.first(where: { $0.collectionId == id }) {
                newItems.append(collection)
            }
            return .just(.checkCollection(newItems))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case .checkCollection(let collections):
            newState.selectedItems = collections
        }
        return newState
    }
}
