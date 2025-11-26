import UIKit

import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionListReactor: Reactor {
    public enum Route {
        case none
        case detail(CollectionResponse)
    }

    public enum Action {
        case itemTapped(Int)
        case viewWillAppear
        case completeAdding
    }

    public enum Mutation {
        case navigateTo(Route)
        case setListData([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var collectionList: [CollectionResponse]
    }

    // MARK: - Properties
    public var initialState: State
    private let disposeBag = DisposeBag()

    private let fetchCollectionListUseCase: FetchCollectionListUseCase
   

    public init(fetchCollectionListUseCase: FetchCollectionListUseCase) {
        self.fetchCollectionListUseCase = fetchCollectionListUseCase
        self.initialState = State(route: .none, collectionList: [])
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchCollectionListUseCase.execute().map { .setListData($0) }
        case .itemTapped(let index):
            return .just(.navigateTo(.detail(currentState.collectionList[index])))
        case .completeAdding:
            return fetchCollectionListUseCase.execute()
                .map {.setListData($0)}
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setListData(let data):
            newState.collectionList = data
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
