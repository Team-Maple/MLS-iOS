import DomainInterface
import ReactorKit
import RxSwift

open class DictionaryListReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
    }

    // MARK: - Action
    public enum Action {
        case toggleBookmark(Int, Bool)
        case viewWillAppear
        case sortButtonTapped
        case filterButtonTapped
        case sortOptionSelected(SortType)
        case filterOptionSelected(startLevel: Int, endLevel: Int)
        case itemFilterOptionSelected([(String, String)])
        case setCurrentPage
        case fetchList
        case fetchListFilter
        case undoLastDeletedBookmark
    }

    // MARK: - Mutation
    public enum Mutation {
        case setListItem(DictionaryMainResponse)
        case showSortFilter
        case showFilter
        case setSort(String)
        case setFilter(start: Int?, end: Int?)
        case setCurrentPage
        case initPage
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryMainItemResponse?)
        case setJobId([Int])
        case setCategoryId([Int])
        case updateBookmarkState(id: Int, isSelected: Bool)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route
        public var listItems: [DictionaryMainItemResponse] = []
        public var type: DictionaryType

        public var keyword: String?
        public var jobId: [Int]?
        public var categoryIds: [Int]?
        public var sort: String?
        public var startLevel: Int?
        public var endLevel: Int?

        public var currentPage = 0
        public var totalCounts = 0

        var isLogin: Bool
        var lastDeletedBookmark: DictionaryMainItemResponse?
    }

    public var initialState: State

    // MARK: - UseCases
    private let checkLoginUseCase: CheckLoginUseCase
    private let dictionaryAllListUseCase: FetchDictionaryAllListUseCase
    private let dictionaryMapListUseCase: FetchDictionaryMapListUseCase
    private let dictionaryItemListUseCase: FetchDictionaryItemListUseCase
    private let dictionaryQuestListUseCase: FetchDictionaryQuestListUseCase
    private let dictionaryNpcListUseCase: FetchDictionaryNpcListUseCase
    private let dictionaryListUseCase: FetchDictionaryMonsterListUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase
    private let parseItemFilterResultUseCase: ParseItemFilterResultUseCase

    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        type: DictionaryType,
        keyword: String?,
        checkLoginUseCase: CheckLoginUseCase,
        dictionaryAllListUseCase: FetchDictionaryAllListUseCase,
        dictionaryMapListUseCase: FetchDictionaryMapListUseCase,
        dictionaryItemListUseCase: FetchDictionaryItemListUseCase,
        dictionaryQuestListUseCase: FetchDictionaryQuestListUseCase,
        dictionaryNpcListUseCase: FetchDictionaryNpcListUseCase,
        dictionaryListUseCase: FetchDictionaryMonsterListUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        parseItemFilterResultUseCase: ParseItemFilterResultUseCase
    ) {
        self.initialState = State(route: .none, type: type, keyword: keyword, isLogin: false)
        self.checkLoginUseCase = checkLoginUseCase
        self.dictionaryAllListUseCase = dictionaryAllListUseCase
        self.dictionaryMapListUseCase = dictionaryMapListUseCase
        self.dictionaryItemListUseCase = dictionaryItemListUseCase
        self.dictionaryQuestListUseCase = dictionaryQuestListUseCase
        self.dictionaryNpcListUseCase = dictionaryNpcListUseCase
        self.dictionaryListUseCase = dictionaryListUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.parseItemFilterResultUseCase = parseItemFilterResultUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return handleViewWillAppear()

        case let .toggleBookmark(id, isSelected):
            return handleToggleBookmark(id: id, isSelected: isSelected)

        case .sortButtonTapped:
            return .just(.showSortFilter)

        case .filterButtonTapped:
            return .just(.showFilter)

        case let .sortOptionSelected(sort):
            return handleSortOptionSelected(sort: sort)

        case let .filterOptionSelected(startLevel, endLevel):
            return handleFilterOptionSelected(startLevel: startLevel, endLevel: endLevel)

        case .setCurrentPage:
            return .just(.setCurrentPage)

        case .fetchList:
            return fetchList(
                sort: currentState.sort,
                startLevel: currentState.startLevel,
                endLevel: currentState.endLevel
            )

        case .fetchListFilter:
            return fetchList(
                sort: currentState.sort,
                startLevel: currentState.startLevel ?? 1,
                endLevel: currentState.endLevel ?? 200,
                isFilter: true
            )

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case let .itemFilterOptionSelected(results):
            return handleItemFilterOptionSelected(results: results)
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showSortFilter:
            newState.route = .sort(newState.type)
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setListItem(items):
            newState.totalCounts = items.totalElements
            if newState.currentPage == 0 {
                newState.listItems = items.contents
            } else {
                newState.listItems.append(contentsOf: items.contents)
            }
        case let .setSort(sort):
            newState.sort = sort
        case let .setFilter(startLevel, endLevel):
            newState.startLevel = startLevel
            newState.endLevel = endLevel
        case .setCurrentPage:
            newState.currentPage += 1
        case .initPage:
            newState.currentPage = 0
        case let .setLastDeletedBookmark(item):
            newState.lastDeletedBookmark = item
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setJobId(id):
            newState.jobId = id
        case let .setCategoryId(id):
            newState.categoryIds = id
        case let .updateBookmarkState(id, isSelected):
            if let index = newState.listItems.firstIndex(where: { $0.id == id }) {
                if isSelected {
                    newState.listItems[index].bookmarkId = newState.listItems[index].bookmarkId ?? -1
                } else {
                    newState.listItems[index].bookmarkId = nil
                }
            }
        }
        return newState
    }
}

// MARK: - Methods
private extension DictionaryListReactor {
    func fetchList(
        sort: String?,
        startLevel: Int?,
        endLevel: Int?,
        isFilter: Bool = false
    ) -> Observable<Mutation> {
        let response: Observable<DictionaryMainResponse>

        switch currentState.type {
        case .monster:
            response = dictionaryListUseCase.execute(
                type: .monster,
                query: DictionaryListQuery(
                    keyword: currentState.keyword ?? "",
                    page: currentState.currentPage,
                    size: 20,
                    sort: sort,
                    minLevel: startLevel,
                    maxLevel: endLevel
                )
            )

        case .item:
            response = dictionaryItemListUseCase.execute(
                keyword: currentState.keyword ?? "",
                jobId: currentState.jobId,
                minLevel: currentState.startLevel,
                maxLevel: currentState.endLevel,
                categoryIds: currentState.categoryIds,
                page: currentState.currentPage,
                size: 20,
                sort: sort
            )

        case .map:
            response = dictionaryMapListUseCase.execute(
                keyword: currentState.keyword ?? "",
                page: currentState.currentPage,
                size: 20,
                sort: sort ?? "ASC"
            )

        case .npc:
            response = dictionaryNpcListUseCase.execute(
                keyword: currentState.keyword ?? "",
                page: currentState.currentPage,
                size: 20,
                sort: sort ?? "ASC"
            )

        case .quest:
            response = dictionaryQuestListUseCase.execute(
                keyword: currentState.keyword ?? "",
                page: currentState.currentPage,
                size: 20,
                sort: sort ?? "ASC"
            )

        case .total:
            response = dictionaryAllListUseCase.execute(
                keyword: currentState.keyword ?? "",
                page: currentState.currentPage
            )

        default:
            return .empty()
        }

        return response.map { .setListItem($0) }
    }

    func handleViewWillAppear() -> Observable<Mutation> {
        let loginState = checkLoginUseCase.execute()
            .map { Mutation.setLoginState($0) }

        let fetchMutation = fetchList(
            sort: currentState.sort,
            startLevel: currentState.startLevel,
            endLevel: currentState.endLevel
        )

        return .merge([loginState, fetchMutation])
    }

    private func handleToggleBookmark(id: Int, isSelected: Bool) -> Observable<Mutation> {
        guard let index = currentState.listItems.firstIndex(where: { $0.id == id }) else { return .empty() }
        let targetItem = currentState.listItems[index]

        let saveDeleted = isSelected
            ? Observable.just(Mutation.setLastDeletedBookmark(targetItem))
            : .empty()

        let optimistic = Observable.just(Mutation.updateBookmarkState(id: id, isSelected: !isSelected))

        let api = setBookmarkUseCase.execute(
            bookmarkId: isSelected ? targetItem.bookmarkId ?? id : targetItem.id,
            isBookmark: isSelected ? .delete : .set(targetItem.type)
        )
        .andThen(fetchList(
            sort: currentState.sort,
            startLevel: currentState.startLevel,
            endLevel: currentState.endLevel
        ))

        return .concat([saveDeleted, optimistic, api])
    }

    func handleSortOptionSelected(sort: SortType) -> Observable<Mutation> {
        return .concat([
            .just(.setSort(sort.sortParameter)),
            .just(.initPage)
        ])
    }

    func handleFilterOptionSelected(startLevel: Int?, endLevel: Int?) -> Observable<Mutation> {
        return .concat([
            .just(.setFilter(start: startLevel, end: endLevel)),
            .just(.initPage)
        ])
        .concat(Observable.deferred { [weak self] in
            guard let self = self else { return .empty() }
            return self.fetchList(
                sort: self.currentState.sort,
                startLevel: startLevel,
                endLevel: endLevel,
                isFilter: true
            )
        })
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }

        let optimistic = Observable.just(Mutation.updateBookmarkState(id: lastDeleted.id, isSelected: true))

        let api = setBookmarkUseCase.execute(
            bookmarkId: lastDeleted.id,
            isBookmark: .set(lastDeleted.type)
        )
        .andThen(Observable.just(Mutation.setLastDeletedBookmark(nil)))

        return .concat([optimistic, api])
    }

    func handleItemFilterOptionSelected(results: [(String, String)]) -> Observable<Mutation> {
        let criteria = parseItemFilterResultUseCase.execute(results: results)
        return .concat([
            .just(.setJobId(criteria.jobIds)),
            .just(.setFilter(start: criteria.startLevel, end: criteria.endLevel)),
            .just(.setCategoryId(criteria.categoryIds)),
            .just(.initPage)
        ])
        .concat(Observable.deferred { [weak self] in
            guard let self = self else { return .empty() }
            return self.fetchList(
                sort: self.currentState.sort,
                startLevel: self.currentState.startLevel,
                endLevel: self.currentState.endLevel,
                isFilter: true
            )
        })
    }
}
