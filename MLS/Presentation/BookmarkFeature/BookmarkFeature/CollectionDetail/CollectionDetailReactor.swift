import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionDetailReactor: Reactor {
    public enum Route {
        case none
        case toMain
        case dismiss
        case edit
        case detail(DictionaryType, Int)
    }

    public enum Action {
        case viewWillAppear
        case backButtonTapped
        case editButtonTapped
        case addButtonTapped
        case bookmarkButtonTapped
        case toggleBookmark(Int, Bool)
        case selectSetting(CollectionSettingMenu)
        case changeName(String)
        case undoLastDeletedBookmark
        case dataTapped(Int)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setItems([BookmarkResponse])
        case setMenu(CollectionSettingMenu)
        case setName(String)
        case setLastDeletedBookmark(BookmarkResponse?)
    }

    public struct State {
        @Pulse var route: Route
        @Pulse var collectionMenu: CollectionSettingMenu?
        var sections: [String] {
            return type.pageTabList.map { $0.title }
        }
        let type = DictionaryMainViewType.bookmark
        var collection: CollectionResponse
        var bookmarks = [BookmarkResponse]()
        var lastDeletedBookmark: BookmarkResponse?
    }

    // MARK: - Properties
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchCollectionUseCase: FetchCollectionUseCase

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(setBookmarkUseCase: SetBookmarkUseCase, fetchCollectionUseCase: FetchCollectionUseCase, collection: CollectionResponse) {
        self.initialState = State(route: .none, collection: collection)
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchCollectionUseCase = fetchCollectionUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleBookmark(let id, let isSelected):
            guard let bookmarkItem = currentState.bookmarks.first(where: { $0.originalId == id }) else { return .empty() }

            let saveDeletedMutation: Observable<Mutation> =
                isSelected ? .just(.setLastDeletedBookmark(bookmarkItem))
                    : .just(.setLastDeletedBookmark(nil))

            return saveDeletedMutation
                .concat(
                    setBookmarkUseCase.execute(
                        bookmarkId: isSelected ? bookmarkItem.bookmarkId : id,
                        isBookmark: isSelected ? .delete : .set(bookmarkItem.type)
                    )
                    .andThen(fetchCollectionUseCase.execute(id: currentState.collection.collectionId).map { .setItems($0) })
                )
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .editButtonTapped:
            return .just(.navigateTo(.edit))
        case .viewWillAppear:
            return fetchCollectionUseCase.execute(id: currentState.collection.collectionId)
                .map { .setItems($0) }
        case .addButtonTapped:
            // 컬렉션 추가
            return .empty()
        case .bookmarkButtonTapped:
            return .just(.navigateTo(.toMain))
        case .selectSetting(let menu):
            return .just(.setMenu(menu))
        case .changeName(let name):
            return .just(.setName(name))
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
            return setBookmarkUseCase.execute(
                bookmarkId: lastDeleted.originalId,
                isBookmark: .set(lastDeleted.type)
            )
            .andThen(
                Observable.concat([
                    // 불러오기
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case .dataTapped(let index):
            let item = currentState.bookmarks[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.navigateTo(.detail(type, item.originalId)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setItems(let items):
            newState.bookmarks = items
        case .navigateTo(let route):
            newState.route = route
        case .setMenu(let menu):
            newState.collectionMenu = menu
        case .setName(let name):
            newState.collection.name = name
        case .setLastDeletedBookmark(let bookmark):
            newState.lastDeletedBookmark = bookmark
        }
        return newState
    }
}
