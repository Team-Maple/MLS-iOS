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
        case sortOptionSelected(SortType) // 정렬 옵션 선택 시 액션
        case filterOptionSelected(startLevel: Int, endLevel: Int) // 필터 옵션 선택 시 액션
        case setCurrentPage
        case fetchList // data 불러오기
        case fetchListFilter // 필터링된 data 불러오기
        case undoLastDeletedBookmark
       // case itemFilterOptionSelected([String]) // 아이템 필터 옵션 선택 시 액션
    }

    // MARK: - Mutation
    public enum Mutation {
        case setListItem(DictionaryMainResponse)
        case setFilterMonsterItem(DictionaryMainResponse)
        case setFilterItemsItem(DictionaryMainResponse)
        case showSortFilter
        case showFilter
        case setSort(String)
        case setFilter(start: Int, end: Int)
        case setCurrentPage
        case initPage
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryMainItemResponse?)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route
        public var listItems: [DictionaryMainItemResponse] = []
        public var type: DictionaryType

        // 필터 조건
        public var keyword: String?
        public var jobId: Int?
        public var minLevel: Int?
        public var maxLevel: Int?
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
        setBookmarkUseCase: SetBookmarkUseCase
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
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            // 로그인 체크 + 초기 데이터 fetch
            return checkLoginUseCase.execute()
                .flatMap { [weak self] isLoggedIn -> Observable<Mutation> in
                    guard let self = self else { return .empty() }

//                    if !isLoggedIn {
//                        // 로그인 안 되어 있으면 상태만 업데이트
//                        return .just(.setLoginState(false))
//                    }

                    // 로그인 되어 있으면 상태 업데이트 후 초기 데이터 fetch
                    let loginMutation: Observable<Mutation> = .just(.setLoginState(true))
                    let fetchMutation: Observable<Mutation>

                    // monster: keyword, minLevel, maxLevel, page, size, sort
                    // npc: keyword, page, size, sort
                    // quest: keyword, page, size, sort
                    // item: keyword, jobId, minLevel, maxLevel, categoryIds, page, size, sort
                    // 몬스터, 아이템을 제외하고는 피그마 상으로는 정렬이 불가능한데, API에는 정렬 옵션이 있음. -> npc, quest,map 도 일단 정렬 옵션 추가
                    switch self.currentState.type {
                    case .monster:
                        fetchMutation = Observable.concat([
                            .just(.initPage), // 먼저 페이지 초기화
                            self.dictionaryListUseCase
                                .execute(
                                    type: .monster,
                                    query: DictionaryListQuery(keyword: self.currentState.keyword ?? "", page: self.currentState.currentPage, size: 20, sort: nil)
                                )
                                .map { Mutation.setListItem($0) }
                        ])
                    case .npc:
                        fetchMutation = Observable.concat([
                            .just(.initPage),
                            self.dictionaryNpcListUseCase
                                .execute(keyword: self.currentState.keyword ?? "", page: self.currentState.currentPage, size: 20, sort: nil)
                                .map { Mutation.setListItem($0) }
                        ])
                    case .quest:
                        fetchMutation = Observable.concat([
                            .just(.initPage),
                            self.dictionaryQuestListUseCase
                                .execute(keyword: self.currentState.keyword ?? "", page: self.currentState.currentPage, size: 20, sort: nil)
                                .map { Mutation.setListItem($0) }
                        ])
                    case .item:
                        fetchMutation = Observable.concat([
                            .just(.initPage),
                            self.dictionaryItemListUseCase
                                .execute(keyword: self.currentState.keyword ?? "", jobId: nil, minLevel: nil, maxLevel: nil, categoryIds: nil, page: self.currentState.currentPage, size: 20, sort: nil)
                                .map { Mutation.setListItem($0) }
                        ])
                    case .map:
                        fetchMutation = Observable.concat([
                            .just(.initPage),
                            self.dictionaryMapListUseCase
                                .execute(keyword: self.currentState.keyword ?? "", page: self.currentState.currentPage, size: 20, sort: nil)
                                .map { Mutation.setListItem($0) }
                        ])
                    case .total:
                        fetchMutation = Observable.concat([
                            .just(.initPage),
                            self.dictionaryAllListUseCase.execute(keyword: self.currentState.keyword ?? "", page: self.currentState.currentPage).map {Mutation.setListItem($0)}
                        ])
                    default:
                        fetchMutation = .empty()
                    }

                    return Observable.concat([loginMutation, fetchMutation])
                }

        case let .toggleBookmark(id, isSelected):
            guard let type = currentState.type.toItemType,
                  let bookmarkItem = currentState.listItems.first(where: { $0.id == id }) else { return .empty() }
            let bookmarkId = bookmarkItem.bookmarkId ?? 0

            let saveDeletedMutation: Observable<Mutation> = isSelected ? .just(.setLastDeletedBookmark(bookmarkItem)) : .just(.setLastDeletedBookmark(nil))

            return saveDeletedMutation
                .concat(
                    setBookmarkUseCase.execute(
                        bookmarkId: isSelected ? bookmarkId : id,
                        isBookmark: isSelected ? .delete : .set(type)
                    )
                    .andThen(
                        Observable.concat([
                            .just(.initPage),
                            fetchList(sort: currentState.sort, startLevel: currentState.startLevel, endLevel: currentState.endLevel)
                        ])
                    )
                )

        case .sortButtonTapped:
            return .just(.showSortFilter)
        case .filterButtonTapped:
            return .just(.showFilter)
        case let .sortOptionSelected(sort):
            return .concat([
                .just(.setSort(sort.sortParameter)),
                .just(.initPage)
            ])
        case let .filterOptionSelected(startLevel, endLevel):
            // 필터 선택 후 페이지 초기화
            return .concat([
                .just(.setFilter(start: startLevel, end: endLevel)),
                .just(.initPage)
            ])
            .concat(Observable.deferred { [weak self] in
                // 상태 적용 이후 호출
                guard let self = self else { return .empty() }
                return self.fetchListFilter(sort: self.currentState.sort, startLevel: startLevel, endLevel: endLevel)
            })
        case .setCurrentPage:
            /* 기존 구조의 문제점
             현재 상태에서 currentPage == 0
             .setCurrentPage 전달됨 -> 나중에 reduce에서 currentPage += 1 적용 됨
             하지만 이 시점에 fetchList는 아직 currentPage == 0인 상태로 실행.
             개선필요. -> fetchList 액션 추가
             setCurrentPage 후에 fetchList 호출 함으로써 페이지 올리고, 데이터 불러오기
             */
            return .just(.setCurrentPage)
        case .fetchList:
            return fetchList(sort: currentState.sort, startLevel: currentState.startLevel, endLevel: currentState.endLevel)
        case .fetchListFilter:
            return fetchListFilter(sort: currentState.sort, startLevel: currentState.startLevel ?? 1, endLevel: currentState.endLevel ?? 200)
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
            return setBookmarkUseCase.execute(
                bookmarkId: lastDeleted.id,
                isBookmark: .set(lastDeleted.type)
            )
            .andThen(
                Observable.concat([
                    .just(.initPage),
                    fetchList(sort: currentState.sort, startLevel: currentState.startLevel, endLevel: currentState.endLevel),
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        }
    }

    // MARK: - Fetch List (필터 적용)
    private func fetchListFilter(sort: String?, startLevel: Int = 1, endLevel: Int = 200) -> Observable<Mutation> {
        switch currentState.type {
        case .monster:
            return dictionaryListUseCase
                .execute(type: .monster, query: DictionaryListQuery(page: currentState.currentPage, size: 20, sort: sort, minLevel: startLevel, maxLevel: endLevel))
                .map { Mutation.setFilterMonsterItem($0) }
        case .item:
            return dictionaryItemListUseCase
                .execute(
                    keyword: currentState.keyword,
                    jobId: currentState.jobId,
                    minLevel: currentState.minLevel,
                    maxLevel: currentState.maxLevel,
                    categoryIds: currentState.categoryIds,
                    page: currentState.currentPage,
                    size: 20,
                    sort: sort
                )
                .map { Mutation.setFilterItemsItem($0) }
        default:
            return .empty()
        }
    }

    private func fetchList(sort: String?, startLevel: Int?, endLevel: Int?) -> Observable<Mutation> {
        switch currentState.type {
        case .monster:
            return dictionaryListUseCase
                .execute(type: .monster, query: DictionaryListQuery(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: sort, minLevel: startLevel, maxLevel: endLevel))
                .map { Mutation.setListItem($0) }
        case .item:
            return dictionaryItemListUseCase
                .execute(
                    keyword: currentState.keyword,
                    jobId: currentState.jobId,
                    minLevel: currentState.minLevel,
                    maxLevel: currentState.maxLevel,
                    categoryIds: currentState.categoryIds,
                    page: currentState.currentPage,
                    size: 20,
                    sort: sort
                )
                .map { Mutation.setListItem($0) }
        case .map:
            return dictionaryMapListUseCase
                .execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                .map { Mutation.setListItem($0) }
        case .npc:
            return dictionaryNpcListUseCase
                .execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                .map { Mutation.setListItem($0) }
        case .quest:
            return dictionaryQuestListUseCase
                .execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                .map { Mutation.setListItem($0) }
        case .total:
            return dictionaryAllListUseCase.execute(keyword: currentState.keyword ?? "", page: currentState.currentPage).map { Mutation.setListItem($0) }
        default:
            return .empty()
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFilterMonsterItem(items):
            newState.listItems = items.contents
        case let .setFilterItemsItem(items):
            newState.listItems = items.contents
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
        case .setLoginState(let isLogin):
            newState.isLogin = isLogin
        }
        return newState
    }
}
