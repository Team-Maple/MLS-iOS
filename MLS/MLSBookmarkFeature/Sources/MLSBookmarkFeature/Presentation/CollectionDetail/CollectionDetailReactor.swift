import MLSBookmarkFeatureInterface
import MLSDictionaryFeatureInterface

import ReactorKit
import RxSwift

final class CollectionDetailReactor: Reactor {
    enum Route {
        case none
        case toMain
        case dismiss
        case edit
        case detail(DictionaryType, Int)
    }

    enum Action {
        case viewWillAppear
        case backButtonTapped
        case editButtonTapped
        case addButtonTapped
        case bookmarkButtonTapped
        case selectSetting(CollectionSettingMenu)
        case changeName(String)
        case dataTapped(Int)
        case deleteCollection
    }

    enum Mutation {
        case navigateTo(Route)
        case setItems([BookmarkResponse])
        case setMenu(CollectionSettingMenu)
        case setName(String)
    }

    struct State {
        @Pulse var route: Route
        @Pulse var collectionMenu: CollectionSettingMenu?
        var collection: CollectionResponse
    }

    var initialState: State
    private let collectionRepository: CollectionRepository

    init(collection: CollectionResponse, collectionRepository: CollectionRepository) {
        self.initialState = State(route: .none, collection: collection)
        self.collectionRepository = collectionRepository
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .editButtonTapped:
            return .just(.navigateTo(.edit))
        case .viewWillAppear:
            return collectionRepository.fetchCollection(id: currentState.collection.collectionId)
                .map { .setItems($0) }
        case .addButtonTapped, .bookmarkButtonTapped:
            return .just(.navigateTo(.toMain))
        case .selectSetting(let menu):
            return .just(.setMenu(menu))
        case .changeName(let name):
            return .just(.setName(name))
        case .dataTapped(let index):
            let item = currentState.collection.recentBookmarks[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.navigateTo(.detail(type, item.originalId)))
        case .deleteCollection:
            return collectionRepository.deleteCollection(collectionId: currentState.collection.collectionId)
                .andThen(.just(.navigateTo(.dismiss)))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setItems(let items):
            newState.collection.recentBookmarks = items
        case .navigateTo(let route):
            newState.route = route
        case .setMenu(let menu):
            newState.collectionMenu = menu
        case .setName(let name):
            newState.collection.name = name
        }
        return newState
    }
}
