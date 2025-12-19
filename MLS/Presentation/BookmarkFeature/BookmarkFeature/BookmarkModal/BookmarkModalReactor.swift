import BookmarkFeatureInterface
import DomainInterface

import ReactorKit
import RxSwift

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case dismissWithData
        case addCollection
        case collectionError
    }

    public enum Action {
        case backButtonTapped
        case addButtonTapped
        case completeAdding
        case addCollectionTapped
        case selectItem(Int)
        case viewWillAppear
    }

    public enum Mutation {
        case navigatTo(Route)
        case checkCollection([CollectionResponse])
        case setCollection([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var bookmarkIds: [Int]
        var collections = [CollectionResponse]()
        var selectedItems = [CollectionResponse]()
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase

    public init(bookmarkIds: [Int], fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase) {
        self.initialState = State(route: .none, bookmarkIds: bookmarkIds)
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionAndBookmarkUseCase = addCollectionAndBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .completeAdding:
            return fetchCollectionListUseCase.execute(sort: nil)
                .map { .setCollection($0) }

        case .addButtonTapped:
            return addCollectionAndBookmarkUseCase
                .execute(
                    collectionIds: currentState.selectedItems.map { $0.collectionId },
                    bookmarkIds: currentState.bookmarkIds
                )
                .andThen(.just(.navigatTo(.dismissWithData)))
                .catch { _ in
                    .just(.navigatTo(.collectionError))
                }

        case .backButtonTapped:
            return .just(.navigatTo(.dismiss))

        case .addCollectionTapped:
            return .just(.navigatTo(.addCollection))

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
        case .navigatTo(let route):
            newState.route = route
        case .checkCollection(let collections):
            newState.selectedItems = collections
        case .setCollection(let collections):
            newState.collections = collections
        }
        return newState
    }
}
