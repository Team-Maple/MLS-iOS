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
        case deleteCollection
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
        var lastDeletedBookmark: BookmarkResponse?
    }

    // MARK: - Properties
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let fetchCollectionUseCase: FetchCollectionUseCase
    private let deleteCollectionUseCase: DeleteCollectionUseCase
    private let addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(collection: CollectionResponse, setBookmarkUseCase: SetBookmarkUseCase, fetchCollectionUseCase: FetchCollectionUseCase, deleteCollectionUseCase: DeleteCollectionUseCase, addCollectionAndBookmarkUseCase: AddCollectionAndBookmarkUseCase) {
        self.initialState = State(route: .none, collection: collection)
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchCollectionUseCase = fetchCollectionUseCase
        self.deleteCollectionUseCase = deleteCollectionUseCase
        self.addCollectionAndBookmarkUseCase = addCollectionAndBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleBookmark(let id, let isSelected):
            guard let bookmarkItem = currentState.collection.recentBookmarks.first(where: { $0.originalId == id }) else { return .empty() }

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
            return .just(.navigateTo(.toMain))
        case .bookmarkButtonTapped:
            return .just(.navigateTo(.toMain))
        case .selectSetting(let menu):
            return .just(.setMenu(menu))
        case .changeName(let name):
            return .just(.setName(name))
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark,
            let lastDeletedBookmarkId = currentState.lastDeletedBookmark?.bookmarkId else { return .empty() }
            return setBookmarkUseCase.execute(
                bookmarkId: lastDeleted.originalId,
                isBookmark: .set(lastDeleted.type)
            )
            // 북마크 다시 설정시 이전 collection을 전부 추적해야하고 새로 바뀐 북마크ID가 필요하여 현재는 원할하게 동작하지 않음
            .andThen(addCollectionAndBookmarkUseCase.execute(collectionIds: [currentState.collection.collectionId], bookmarkIds: [lastDeletedBookmarkId]))
            .andThen(
                Observable.concat([
                    fetchCollectionUseCase.execute(id: currentState.collection.collectionId)
                        .map { .setItems($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case .dataTapped(let index):
            let item = currentState.collection.recentBookmarks[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.navigateTo(.detail(type, item.originalId)))
        case .deleteCollection:
            return deleteCollectionUseCase.execute(collectionId: currentState.collection.collectionId)
                .andThen(.just(.navigateTo(.dismiss)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
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
        case .setLastDeletedBookmark(let bookmark):
            newState.lastDeletedBookmark = bookmark
        }
        return newState
    }
}
