import DomainInterface
import ReactorKit
import RxSwift

public final class BookmarkListReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
    }

    // MARK: - Action
    public enum Action {
        case viewWillAppear
        case toggleBookmark(Int, Bool)
        case sortButtonTapped
        case filterButtonTapped
        case fetchList
        case setCurrentPage
        case sortOptionSelected(SortType)
        case filterOptionSelected(startLevel: Int, endLevel: Int)
        case undoLastDeletedBookmark
    }

    // MARK: - Mutation
    public enum Mutation {
        case setItems([BookmarkResponse])
        case showSortFilter
        case showFilter
        case setLoginState(Bool)
        case setCurrentPage
        case initPage
        case setSort(SortType)
        case setFilter(start: Int, end: Int)
        case setLastDeletedBookmark(BookmarkResponse?)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route
        var items: [BookmarkResponse] = []
        var type: DictionaryType
        var isLogin: Bool
        var currentPage: Int = 0
        var sort: SortType?
        var startLevel: Int?
        var endLevel: Int?
        var lastDeletedBookmark: BookmarkResponse?
    }

    public var initialState: State

    // MARK: - UseCases
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    private let fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase
    private let fetchItemBookmarkUseCase: FetchItemBookmarkUseCase
    private let fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase
    private let fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase
    private let fetchMapBookmarkUseCase: FetchMapBookmarkUseCase

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        type: DictionaryType,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase,
        fetchItemBookmarkUseCase: FetchItemBookmarkUseCase,
        fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase,
        fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase,
        fetchMapBookmarkUseCase: FetchMapBookmarkUseCase
    ) {
        self.initialState = State(route: .none, type: type, isLogin: false)
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchMonsterBookmarkUseCase = fetchMonsterBookmarkUseCase
        self.fetchItemBookmarkUseCase = fetchItemBookmarkUseCase
        self.fetchNPCBookmarkUseCase = fetchNPCBookmarkUseCase
        self.fetchQuestBookmarkUseCase = fetchQuestBookmarkUseCase
        self.fetchMapBookmarkUseCase = fetchMapBookmarkUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return checkLoginUseCase.execute()
                .flatMap { [weak self] isLoggedIn -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    if !isLoggedIn {
                        return .just(.setLoginState(false))
                    } else {
                        return Observable.concat([
                            .just(.setLoginState(true)),
                            .just(.initPage),
                            self.fetchList()
                        ])
                    }
                }

        case let .toggleBookmark(id, isSelected):
            guard let type = currentState.type.toItemType,
                  let bookmarkItem = currentState.items.first(where: { $0.originalId == id }) else { return .empty() }
            let saveDeletedMutation: Observable<Mutation> = isSelected ? .just(.setLastDeletedBookmark(bookmarkItem)) : .just(.setLastDeletedBookmark(nil))
            return saveDeletedMutation
                .concat(
                    setBookmarkUseCase.execute(bookmarkId: isSelected ? bookmarkItem.bookmarkId : id, isBookmark: isSelected ? .delete : .set(type))
                    .andThen(
                        Observable.concat([
                            .just(.initPage),
                            fetchList()
                        ])
                    )
                )

        case .sortButtonTapped:
            return .just(.showSortFilter)

        case .filterButtonTapped:
            return .just(.showFilter)

        case .fetchList:
            guard currentState.isLogin else { return .empty() }
            return fetchList()

        case .setCurrentPage:
            guard currentState.isLogin else { return .empty() }
            return Observable.concat([
                .just(.setCurrentPage),
                fetchList()
            ])

        case let .sortOptionSelected(sort):
            return Observable.concat([
                .just(.setSort(sort)),
                .just(.initPage),
                fetchList()
            ])

        case let .filterOptionSelected(startLevel, endLevel):
            return Observable.concat([
                .just(.setFilter(start: startLevel, end: endLevel)),
                .just(.initPage),
                fetchList()
            ])
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
            return setBookmarkUseCase.execute(
                bookmarkId: lastDeleted.originalId,
                isBookmark: .set(lastDeleted.type)
            )
            .andThen(
                Observable.concat([
                    .just(.initPage),
                    fetchList(),
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        }
    }

    // MARK: - Fetch List
    private func fetchList() -> Observable<Mutation> {
        switch currentState.type {
        case .monster:
            return fetchMonsterBookmarkUseCase.execute(
                minLevel: currentState.startLevel ?? 1,
                maxLevel: currentState.endLevel ?? 200,
                page: currentState.currentPage,
                size: 20,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .item:
            return fetchItemBookmarkUseCase.execute(
                jobId: nil,
                minLevel: currentState.startLevel,
                maxLevel: currentState.endLevel,
                categoryIds: nil,
                page: currentState.currentPage,
                size: 20,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .npc:
            return fetchNPCBookmarkUseCase.execute(
                page: currentState.currentPage,
                size: 20,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .quest:
            return fetchQuestBookmarkUseCase.execute(
                page: currentState.currentPage,
                size: 20,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .map:
            return fetchMapBookmarkUseCase.execute(
                page: currentState.currentPage,
                size: 20,
                sort: currentState.sort
            ).map { .setItems($0) }

        default:
            return .empty()
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setItems(response):
            if newState.currentPage == 0 {
                newState.items = response
            } else {
                newState.items.append(contentsOf: response)
            }

        case .showSortFilter:
            newState.route = .sort(newState.type)

        case .showFilter:
            newState.route = .filter(newState.type)

        case let .setLoginState(isLogin):
            newState.isLogin = isLogin

        case .setCurrentPage:
            newState.currentPage += 1

        case .initPage:
            newState.currentPage = 0

        case let .setSort(sort):
            newState.sort = sort

        case let .setFilter(start, end):
            newState.startLevel = start
            newState.endLevel = end
        case .setLastDeletedBookmark(let item):
            newState.lastDeletedBookmark = item
        }

        return newState
    }
}
