import MLSBookmarkFeatureInterface
import ReactorKit
import RxSwift

final class BookmarkListReactor: Reactor {
    enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
        case detail(DictionaryType, Int)
        case dictionary
        case login
        case edit
        case bookmarkError
    }

    enum UIEvent {
        case none
        case add(BookmarkResponse)
        case delete(BookmarkResponse)
        case undo
        case login
    }

    enum ViewState: Equatable {
        case loginWithData
        case loginWithoutData
        case logout
    }

    enum Action {
        case viewWillAppear
        case toggleBookmark(Int)
        case sortButtonTapped
        case filterButtonTapped
        case editButtonTapped
        case fetchList
        case sortOptionSelected(SortType)
        case filterOptionSelected(startLevel: Int, endLevel: Int)
        case undoLastDeletedBookmark
        case dataTapped(Int)
        case emptyButtonTapped
        case itemFilterOptionSelected([(String, String)])
        case showLogin
    }

    enum Mutation {
        case setItems([BookmarkResponse])
        case setLoginState(Bool)
        case setSort(SortType)
        case setFilter(start: Int?, end: Int?)
        case setLastDeletedBookmark(BookmarkResponse?)
        case navigateTo(Route)
        case setJobId([Int])
        case setCategoryId([Int])
        case setEvent(UIEvent)
    }

    struct State {
        @Pulse var uiEvent: UIEvent = .none
        @Pulse var route: Route
        var items: [BookmarkResponse] = []
        var type: DictionaryType
        var isLogin: Bool
        var jobId: [Int]?
        var categoryIds: [Int]?
        var sort: SortType?
        var startLevel: Int?
        var endLevel: Int?
        var lastDeletedBookmark: BookmarkResponse?
        var viewState: ViewState {
            if !isLogin { return .logout } else if items.isEmpty { return .loginWithoutData } else { return .loginWithData }
        }
    }

    var initialState: State

    private let authRepository: BookmarkAuthRepository
    private let bookmarkRepository: BookmarkRepository
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    init(
        type: DictionaryType,
        authRepository: BookmarkAuthRepository,
        bookmarkRepository: BookmarkRepository,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    ) {
        self.initialState = State(route: .none, type: type, isLogin: false)
        self.authRepository = authRepository
        self.bookmarkRepository = bookmarkRepository
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return authRepository.isLoggedIn()
                .flatMap { [weak self] isLogin -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    if !isLogin {
                        return .just(.setLoginState(false))
                    } else {
                        return Observable.concat([.just(.setLoginState(true)), self.fetchList()])
                    }
                }

        case let .toggleBookmark(id):
            return handleToggle(id: id)

        case .sortButtonTapped:
            return .just(.navigateTo(.sort(currentState.type)))

        case .filterButtonTapped:
            return .just(.navigateTo(.filter(currentState.type)))

        case .fetchList:
            guard currentState.isLogin else { return .empty() }
            return fetchList()

        case let .sortOptionSelected(sort):
            return Observable.concat([.just(.setSort(sort)), fetchList(sort: sort)])

        case let .filterOptionSelected(startLevel, endLevel):
            return Observable.concat([.just(.setFilter(start: startLevel, end: endLevel)), fetchList()])

        case .undoLastDeletedBookmark:
            return handleUndo()

        case let .dataTapped(index):
            let item = currentState.items[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.navigateTo(.detail(type, item.originalId)))

        case .emptyButtonTapped:
            if currentState.viewState == .logout {
                return .just(.navigateTo(.login))
            } else {
                return .just(.navigateTo(.dictionary))
            }

        case .editButtonTapped:
            return .just(.navigateTo(.edit))

        case let .itemFilterOptionSelected(results):
            let criteria = parseItemFilterResultUseCase.execute(results: results)
            return Observable.concat([
                .just(.setJobId(criteria.jobIds)),
                .just(.setFilter(start: criteria.startLevel, end: criteria.endLevel)),
                .just(.setCategoryId(criteria.categoryIds))
            ])
            .concat(Observable.deferred { [weak self] in
                guard let self else { return .empty() }
                return self.fetchList()
            })

        case .showLogin:
            return .just(.setEvent(.login))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setItems(response): newState.items = response
        case let .setLoginState(isLogin): newState.isLogin = isLogin
        case let .setSort(sort): newState.sort = sort
        case let .setFilter(start, end):
            newState.startLevel = start
            newState.endLevel = end
        case let .setLastDeletedBookmark(item): newState.lastDeletedBookmark = item
        case let .navigateTo(route): newState.route = route
        case let .setJobId(ids): newState.jobId = ids
        case let .setCategoryId(ids): newState.categoryIds = ids
        case let .setEvent(event): newState.uiEvent = event
        }
        return newState
    }
}

private extension BookmarkListReactor {
    func fetchList(sort: SortType? = nil) -> Observable<Mutation> {
        let resolvedSort = (sort ?? currentState.sort)?.sortParameter
        switch currentState.type {
        case .total:
            return bookmarkRepository.fetchBookmark(sort: resolvedSort).map { .setItems($0) }
        case .monster:
            return bookmarkRepository.fetchMonsterBookmark(
                minLevel: currentState.startLevel ?? 1,
                maxLevel: currentState.endLevel ?? 200,
                sort: resolvedSort
            ).map { .setItems($0) }
        case .item:
            return bookmarkRepository.fetchItemBookmark(
                jobId: nil,
                minLevel: currentState.startLevel,
                maxLevel: currentState.endLevel,
                categoryIds: nil,
                sort: resolvedSort
            ).map { .setItems($0) }
        case .npc:
            return bookmarkRepository.fetchNPCBookmark(sort: resolvedSort).map { .setItems($0) }
        case .quest:
            return bookmarkRepository.fetchQuestBookmark(sort: resolvedSort).map { .setItems($0) }
        case .map:
            return bookmarkRepository.fetchMapBookmark(sort: resolvedSort).map { .setItems($0) }
        default:
            return .empty()
        }
    }

    func handleToggle(id: Int) -> Observable<Mutation> {
        guard let index = currentState.items.firstIndex(where: { $0.originalId == id }) else {
            return .empty()
        }
        let targetItem = currentState.items[index]
        return bookmarkRepository.deleteBookmark(bookmarkId: targetItem.bookmarkId)
            .flatMap { [self] _ -> Observable<Mutation> in
                return Observable.concat([
                    .from([.setLastDeletedBookmark(targetItem), .setEvent(.delete(targetItem))]),
                    self.fetchList()
                ])
            }
            .catch { _ in .just(.navigateTo(.bookmarkError)) }
    }

    func handleUndo() -> Observable<Mutation> {
        guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
        return bookmarkRepository.setBookmark(resourceId: lastDeleted.originalId, type: lastDeleted.type)
            .flatMap { [self] _ -> Observable<Mutation> in
                return Observable.concat([
                    .from([.setLastDeletedBookmark(nil), .setEvent(.add(lastDeleted))]),
                    self.fetchList()
                ])
            }
            .catch { _ in .just(.navigateTo(.bookmarkError)) }
    }
}
