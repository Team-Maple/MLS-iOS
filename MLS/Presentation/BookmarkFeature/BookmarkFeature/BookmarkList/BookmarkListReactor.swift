import DomainInterface

import ReactorKit
import RxSwift

public final class BookmarkListReactor: Reactor {
    // MARK: - Type
    public enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
        case detail(DictionaryType, Int)
        case dictionary
        case login
        case edit
        case bookmarkError
    }

    public enum UIEvent {
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

    // MARK: - Action
    public enum Action {
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

    // MARK: - Mutation
    public enum Mutation {
        case setItems([BookmarkResponse])
        case setLoginState(Bool)
        case setSort(SortType)
        case setFilter(start: Int?, end: Int?)
        case setLastDeletedBookmark(BookmarkResponse?)
        case navigatTo(Route)
        case setJobId([Int])
        case setCategoryId([Int])
        case setEvent(UIEvent)
    }

    // MARK: - State
    public struct State {
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
            if !isLogin {
                return .logout
            } else if items.isEmpty {
                return .loginWithoutData
            } else {
                return .loginWithData
            }
        }
    }

    public var initialState: State

    // MARK: - UseCases
    private let fetchProfileUseCase: FetchProfileUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    private let fetchTotalBookmarkUseCase: FetchBookmarkUseCase
    private let fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase
    private let fetchItemBookmarkUseCase: FetchItemBookmarkUseCase
    private let fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase
    private let fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase
    private let fetchMapBookmarkUseCase: FetchMapBookmarkUseCase
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        type: DictionaryType,
        fetchProfileUseCase: FetchProfileUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        fetchBookmarkUseCase: FetchBookmarkUseCase,
        fetchMonsterBookmarkUseCase: FetchMonsterBookmarkUseCase,
        fetchItemBookmarkUseCase: FetchItemBookmarkUseCase,
        fetchNPCBookmarkUseCase: FetchNPCBookmarkUseCase,
        fetchQuestBookmarkUseCase: FetchQuestBookmarkUseCase,
        fetchMapBookmarkUseCase: FetchMapBookmarkUseCase,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    ) {
        self.initialState = State(route: .none, type: type, isLogin: false)
        self.fetchProfileUseCase = fetchProfileUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.fetchTotalBookmarkUseCase = fetchBookmarkUseCase
        self.fetchMonsterBookmarkUseCase = fetchMonsterBookmarkUseCase
        self.fetchItemBookmarkUseCase = fetchItemBookmarkUseCase
        self.fetchNPCBookmarkUseCase = fetchNPCBookmarkUseCase
        self.fetchQuestBookmarkUseCase = fetchQuestBookmarkUseCase
        self.fetchMapBookmarkUseCase = fetchMapBookmarkUseCase
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchProfileUseCase.execute()
                .flatMap { [weak self] profile -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    if profile == nil {
                        return .just(.setLoginState(false))
                    } else {
                        return Observable.concat([
                            .just(.setLoginState(true)),
                            self.fetchList()
                        ])
                    }
                }

        case let .toggleBookmark(id):
            return handleTogle(id: id)

        case .sortButtonTapped:
            return .just(.navigatTo(.sort(currentState.type)))

        case .filterButtonTapped:
            return .just(.navigatTo(.filter(currentState.type)))

        case .fetchList:
            guard currentState.isLogin else { return .empty() }
            return fetchList()

        case let .sortOptionSelected(sort):
            return Observable.concat([
                .just(.setSort(sort)),
                fetchList(sort: sort)
            ])

        case let .filterOptionSelected(startLevel, endLevel):
            return Observable.concat([
                .just(.setFilter(start: startLevel, end: endLevel)),
                fetchList()
            ])

        case .undoLastDeletedBookmark:
            return handleUndo()

        case let .dataTapped(index):
            let item = currentState.items[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.navigatTo(.detail(type, item.originalId)))
        case .emptyButtonTapped:
            if currentState.viewState == .logout {
                return .just(.navigatTo(.login))
            } else {
                return .just(.navigatTo(.dictionary))
            }
        case .editButtonTapped:
            return .just(.navigatTo(.edit))
        case let .itemFilterOptionSelected(results):
            let criteria = parseItemFilterResultUseCase.execute(results: results)

            return .concat([
                .just(.setJobId(criteria.jobIds)),
                .just(.setFilter(start: criteria.startLevel, end: criteria.endLevel)),
                .just(.setCategoryId(criteria.categoryIds))
            ])
            .concat(Observable.deferred { [weak self] in
                guard let self = self else { return .empty() }
                return self.fetchList()
            })
        case .showLogin:
            return .just(.setEvent(.login))
        }
    }

    // MARK: - Fetch List
    private func fetchList(sort: SortType? = nil) -> Observable<Mutation> {
        switch currentState.type {
        case .total:
            return fetchTotalBookmarkUseCase.execute(
                sort: sort ?? currentState.sort
            ).map { .setItems($0) }

        case .monster:
            return fetchMonsterBookmarkUseCase.execute(
                minLevel: currentState.startLevel ?? 1,
                maxLevel: currentState.endLevel ?? 200,
                sort: sort ?? currentState.sort
            ).map { .setItems($0) }

        case .item:
            return fetchItemBookmarkUseCase.execute(
                jobId: nil,
                minLevel: currentState.startLevel,
                maxLevel: currentState.endLevel,
                categoryIds: nil,
                sort: sort ?? currentState.sort
            ).map { .setItems($0) }

        case .npc:
            return fetchNPCBookmarkUseCase.execute(sort: sort ?? currentState.sort)
                .map { .setItems($0) }

        case .quest:
            return fetchQuestBookmarkUseCase.execute(sort: sort ?? currentState.sort)
                .map { .setItems($0) }

        case .map:
            return fetchMapBookmarkUseCase.execute(sort: sort ?? currentState.sort)
                .map { .setItems($0) }

        default:
            return .empty()
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setItems(response):
            newState.items = response
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setSort(sort):
            newState.sort = sort
        case let .setFilter(start, end):
            newState.startLevel = start
            newState.endLevel = end
        case let .setLastDeletedBookmark(item):
            newState.lastDeletedBookmark = item
        case let .navigatTo(route):
            newState.route = route
        case let .setJobId(ids):
            newState.jobId = ids
        case let .setCategoryId(ids):
            newState.categoryIds = ids
        case let .setEvent(event):
            newState.uiEvent = event
        }

        return newState
    }
}

private extension BookmarkListReactor {
    func handleTogle(id: Int) -> Observable<Mutation> {
        guard let index = currentState.items.firstIndex(where: { $0.originalId == id }) else {
            return .empty()
        }

        let targetItem = currentState.items[index]

        return setBookmarkUseCase.execute(bookmarkId: targetItem.bookmarkId, isBookmark: .delete)
            .flatMap { _ -> Observable<Mutation> in
                let lastItem = Mutation.setLastDeletedBookmark(targetItem)

                let eventMutation = Mutation.setEvent(.delete(targetItem))

                return Observable.concat([
                    .from([lastItem, eventMutation]),
                    self.fetchList()
                ])
            }
            .catch { _ in
                .just(.navigatTo(.bookmarkError))
            }
    }

    func handleUndo() -> Observable<Mutation> {
        guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: lastDeleted.originalId,
            isBookmark: .set(lastDeleted.type)
        )
        .flatMap { _ -> Observable<Mutation> in
            let lastItem = Mutation.setLastDeletedBookmark(nil)

            let event: UIEvent = .add(lastDeleted)
            let eventMutation = Mutation.setEvent(event)

            return Observable.concat([
                .from([lastItem, eventMutation]),
                self.fetchList()
            ])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
