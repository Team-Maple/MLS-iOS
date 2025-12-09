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
    }

    enum ViewState: Equatable {
        case loginWithData
        case loginWithoutData
        case logout
    }

    // MARK: - Action
    public enum Action {
        case viewWillAppear
        case toggleBookmark(Int, Bool)
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
    }

    // MARK: - Mutation
    public enum Mutation {
        case setItems([BookmarkResponse])
        case setLoginState(Bool)
        case setSort(SortType)
        case setFilter(start: Int?, end: Int?)
        case setLastDeletedBookmark(BookmarkResponse?)
        case toNavagate(Route)
        case setJobId([Int])
        case setCategoryId([Int])
    }

    // MARK: - State
    public struct State {
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

        case let .toggleBookmark(id, isSelected):
            guard let bookmarkItem = currentState.items.first(where: { $0.originalId == id }) else { return .empty() }

            let saveDeletedMutation: Observable<Mutation> =
                isSelected ? .just(.setLastDeletedBookmark(bookmarkItem))
                    : .just(.setLastDeletedBookmark(nil))

            return saveDeletedMutation
                .concat(
                    setBookmarkUseCase.execute(
                        bookmarkId: isSelected ? bookmarkItem.bookmarkId : id,
                        isBookmark: isSelected ? .delete : .set(bookmarkItem.type)
                    )
                    .andThen(fetchList())
                )

        case .sortButtonTapped:
            return .just(.toNavagate(.sort(currentState.type)))

        case .filterButtonTapped:
            return .just(.toNavagate(.filter(currentState.type)))

        case .fetchList:
            guard currentState.isLogin else { return .empty() }
            return fetchList()

        case let .sortOptionSelected(sort):
            return Observable.concat([
                .just(.setSort(sort)),
                fetchList()
            ])

        case let .filterOptionSelected(startLevel, endLevel):
            return Observable.concat([
                .just(.setFilter(start: startLevel, end: endLevel)),
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
                    fetchList(),
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case .dataTapped(let index):
            let item = currentState.items[index]
            guard let type = item.type.toDictionaryType else { return .empty() }
            return .just(.toNavagate(.detail(type, item.originalId)))
        case .emptyButtonTapped:
            if currentState.viewState == .logout {
                return .just(.toNavagate(.login))
            } else {
                return .just(.toNavagate(.dictionary))
            }
        case .editButtonTapped:
            return .just(.toNavagate(.edit))
        case .itemFilterOptionSelected(let results):
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
        }
    }

    // MARK: - Fetch List
    private func fetchList() -> Observable<Mutation> {
        switch currentState.type {
        case .total:
            return fetchTotalBookmarkUseCase.execute(
                sort: currentState.sort
            ).map { .setItems($0) }

        case .monster:
            return fetchMonsterBookmarkUseCase.execute(
                minLevel: currentState.startLevel ?? 1,
                maxLevel: currentState.endLevel ?? 200,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .item:
            return fetchItemBookmarkUseCase.execute(
                jobId: nil,
                minLevel: currentState.startLevel,
                maxLevel: currentState.endLevel,
                categoryIds: nil,
                sort: currentState.sort
            ).map { .setItems($0) }

        case .npc:
            return fetchNPCBookmarkUseCase.execute(sort: currentState.sort)
                .map { .setItems($0) }

        case .quest:
            return fetchQuestBookmarkUseCase.execute(sort: currentState.sort)
                .map { .setItems($0) }

        case .map:
            return fetchMapBookmarkUseCase.execute(sort: currentState.sort)
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
        case .toNavagate(let route):
            newState.route = route
        case .setJobId(let ids):
            newState.jobId = ids
        case .setCategoryId(let ids):
            newState.categoryIds = ids
        }

        return newState
    }
}
