import MLSBookmarkFeatureInterface
import MLSDictionaryFeatureInterface

import ReactorKit
import RxSwift

final class CollectionListReactor: Reactor {
    enum Route {
        case none
        case detail(CollectionResponse)
        case sortFilter
    }

    enum Action {
        case itemTapped(Int)
        case viewWillAppear
        case completeAdding
        case sortButtonTapped
        case sortOptionSelected(SortType)
    }

    enum Mutation {
        case navigateTo(Route)
        case setListData([CollectionResponse])
        case setSort(SortType)
    }

    struct State {
        @Pulse var route: Route
        var collectionList: [CollectionResponse]
        var sortFilter: [SortType] = [.korean, .latest]
        var selectedSort: SortType?
    }

    var initialState: State
    private let collectionRepository: CollectionRepository

    init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
        self.initialState = State(route: .none, collectionList: [])
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return collectionRepository.fetchCollectionList(sort: currentState.selectedSort?.sortParameter)
                .map { .setListData($0) }
        case .itemTapped(let index):
            return .just(.navigateTo(.detail(currentState.collectionList[index])))
        case .completeAdding:
            return collectionRepository.fetchCollectionList(sort: currentState.selectedSort?.sortParameter)
                .map { .setListData($0) }
        case .sortButtonTapped:
            return .just(.navigateTo(.sortFilter))
        case .sortOptionSelected(let sort):
            return Observable.concat([
                .just(.setSort(sort)),
                collectionRepository.fetchCollectionList(sort: sort.sortParameter).map { .setListData($0) }
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setListData(let data):
            newState.collectionList = data
        case .navigateTo(let route):
            newState.route = route
        case .setSort(let sort):
            newState.selectedSort = sort
        }
        return newState
    }
}
