import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionDetailReactor: Reactor {
    public enum Route {
        case none
        case toMain
        case dismiss
        case edit
    }

    public enum Action {
        case viewDidAppear
        case backButtonTapped
        case editButtonTapped
        case addButtonTapped
        case bookmarkButtonTapped
        case toggleBookmark(String)
        case selectSetting(CollectionSettingMenu)
        case changeName(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setItems([DictionaryItem])
        case setMenu(CollectionSettingMenu)
        case setName(String)
    }

    public struct State {
        @Pulse var route: Route
        let type = DictionaryMainViewType.bookmark
        var collection: BookmarkCollection
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }

        @Pulse var collectionMenu: CollectionSettingMenu?
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
        case .toggleBookmark(let id):
            return toggleBookmarkUseCase.execute(id: id, type: .total)
                .map { Mutation.setItems($0) }
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .editButtonTapped:
            return .just(.navigateTo(.edit))
        case .viewDidAppear:
            // 데이터 불러오기?
            return .empty()
        case .addButtonTapped:
            // 컬렉션 추가
            return .empty()
        case .bookmarkButtonTapped:
            // 북마크로 이동
            return .empty()
        case .selectSetting(let menu):
            return .just(.setMenu(menu))
        case .changeName(let name):
            return .just(.setName(name))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setItems(let items):
            newState.collection.items = items
        case .navigateTo(let route):
            newState.route = route
        case .setMenu(let menu):
            newState.collectionMenu = menu
        case .setName(let name):
            newState.collection.title = name
        }
        return newState
    }
}
