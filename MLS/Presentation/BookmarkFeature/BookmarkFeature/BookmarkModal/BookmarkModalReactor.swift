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
        case toNavigate(Route)
        case checkCollection([CollectionResponse])
        case setCollection([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var bookmarkId: Int
        var collections = [CollectionResponse]()
        var selectedItems = [CollectionResponse]()
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    private let fetchCollectionListUseCase: FetchCollectionListUseCase
    private let addCollectionsToBookmarkUseCase: AddCollectionsToBookmarkUseCase

    public init(bookmarkId: Int, fetchCollectionListUseCase: FetchCollectionListUseCase, addCollectionsToBookmarkUseCase: AddCollectionsToBookmarkUseCase) {
        self.initialState = State(route: .none, bookmarkId: bookmarkId)
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.addCollectionsToBookmarkUseCase = addCollectionsToBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .completeAdding:
            return fetchCollectionListUseCase.execute()
                .map { .setCollection($0) }

        case .addButtonTapped:
            return addCollectionsToBookmarkUseCase
                .execute(
                    bookmarkId: currentState.bookmarkId,
                    collectionIds: currentState.selectedItems.map { $0.collectionId }
                )
                .do(onError: { error in
                    if let error = error as? DomainHTTPError {
                        print(error)
                    }
                })
                .andThen(.just(.toNavigate(.dismissWithData)))

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
        case .setCollection(let collections):
            newState.collections = collections
        }
        return newState
    }
}
