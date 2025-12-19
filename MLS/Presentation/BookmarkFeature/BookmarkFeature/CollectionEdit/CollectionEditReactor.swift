import UIKit

import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionEditReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case collcectionList
    }

    public enum Action {
        case backButtonTapped
        case addCollectionButtonTapped
        case itemTapped(Int)
    }

    public enum Mutation {
        case navigateTo(Route)
        case checkBookMarks([BookmarkResponse])
        case checkCollections([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var bookmarks: [BookmarkResponse]
        var selectedItems = [BookmarkResponse]()
        var selectedCollections = [CollectionResponse]()
    }

    // MARK: - Properties
    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(bookmarks: [BookmarkResponse]) {
        self.initialState = State(route: .none, bookmarks: bookmarks)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .addCollectionButtonTapped:
            return .just(.navigateTo(.collcectionList))
        case .itemTapped(let index):
            let item = currentState.bookmarks[index]
            var newItems = currentState.selectedItems
            if let index = newItems.firstIndex(where: { $0.originalId == item.originalId }) {
                newItems.remove(at: index)
            } else {
                newItems.append(item)
            }
            return .just(.checkBookMarks(newItems))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .checkBookMarks(let bookmarks):
            newState.selectedItems = bookmarks
        case .checkCollections(let collections):
            newState.selectedCollections = collections
        }
        return newState
    }
}
