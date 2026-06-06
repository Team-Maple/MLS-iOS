import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class BookmarkModalReactor: Reactor {
    enum Route {
        case none
        case dismiss
        case dismissWithData
        case addCollection
        case collectionError
    }

    enum Action {
        case backButtonTapped
        case addButtonTapped
        case completeAdding
        case addCollectionTapped
        case selectItem(Int)
        case viewWillAppear
    }

    enum Mutation {
        case navigateTo(Route)
        case checkCollection([CollectionResponse])
        case setCollection([CollectionResponse])
    }

    struct State {
        @Pulse var route: Route
        var bookmarkIds: [Int]
        var collections = [CollectionResponse]()
        var selectedItems = [CollectionResponse]()
    }

    var initialState: State

    private let collectionRepository: CollectionRepository

    init(bookmarkIds: [Int], collectionRepository: CollectionRepository) {
        self.initialState = State(route: .none, bookmarkIds: bookmarkIds)
        self.collectionRepository = collectionRepository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .completeAdding:
            return collectionRepository.fetchCollectionList(sort: nil)
                .map { .setCollection($0) }

        case .addButtonTapped:
            return collectionRepository.addCollectionAndBookmark(
                collectionIds: currentState.selectedItems.map { $0.collectionId },
                bookmarkIds: currentState.bookmarkIds
            )
            .andThen(.just(.navigateTo(.dismissWithData)))
            .catch { _ in .just(.navigateTo(.collectionError)) }

        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))

        case .addCollectionTapped:
            return .just(.navigateTo(.addCollection))

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

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .checkCollection(let collections):
            newState.selectedItems = collections
        case .setCollection(let collections):
            newState.collections = collections
        }
        return newState
    }
}
