import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import ReactorKit

public final class BookmarkDetailReactor: Reactor {
    public enum Route {
        case none
        case toMain
    }

    public enum Action {
        case viewDidAppear
        case backButtonTapped
        case editButtonTapped
        case addButtonTapped
        case bookmarkButtonTapped
        case toggleBookmark(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setItems([DictionaryItem])
    }

    public struct State {
        @Pulse var route: Route
        let type = DictionaryMainViewType.bookmark
        var collection: BookmarkCollection
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
    }

    // MARK: - Properties
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(toggleBookmarkUseCase: ToggleBookmarkUseCase, collection: BookmarkCollection) {
        self.initialState = State(route: .none, collection: collection)
        self.toggleBookmarkUseCase = toggleBookmarkUseCase

    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .toggleBookmark(id):
            return toggleBookmarkUseCase.execute(id: id, type: .total)
                .map { Mutation.setItems($0) }
        default:
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setItems(let items):
            newState.collection.items = items
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
