import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class CollectionEditReactor: Reactor {
    enum Route {
        case none
        case dismiss
        case collectionList
    }

    enum Action {
        case backButtonTapped
        case addCollectionButtonTapped
        case itemTapped(Int)
    }

    enum Mutation {
        case navigateTo(Route)
        case checkBookmarks([BookmarkResponse])
    }

    struct State {
        @Pulse var route: Route
        var bookmarks: [BookmarkResponse]
        var selectedItems = [BookmarkResponse]()
    }

    var initialState: State

    init(bookmarks: [BookmarkResponse]) {
        self.initialState = State(route: .none, bookmarks: bookmarks)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .addCollectionButtonTapped:
            return .just(.navigateTo(.collectionList))
        case .itemTapped(let index):
            let item = currentState.bookmarks[index]
            var newItems = currentState.selectedItems
            if let idx = newItems.firstIndex(where: { $0.originalId == item.originalId }) {
                newItems.remove(at: idx)
            } else {
                newItems.append(item)
            }
            return .just(.checkBookmarks(newItems))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .checkBookmarks(let bookmarks):
            newState.selectedItems = bookmarks
        }
        return newState
    }
}
