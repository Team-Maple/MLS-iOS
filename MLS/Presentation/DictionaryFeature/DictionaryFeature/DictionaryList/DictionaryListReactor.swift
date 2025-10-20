import DomainInterface

import ReactorKit

open class DictionaryListReactor: Reactor {
    public enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
    }

    public enum Action {
        case toggleBookmark(String)
        case viewWillAppear
        case sortButtonTapped
        case filterButtonTapped
        case sortOptionSelected(SortType) // 정렬 옵션 선택 시 액션
        case filterOptionSelected(startLevel: Int, endLevel: Int) // 필터 옵션 선택 시 액션
        case setCurrentPage
        case fetchList // data 불러오기
        case fetchListFilter // 필터링된 data 불러오기
    }

    public enum Mutation {
        case setListItem(DictionaryMainResponse)
        case setFilterMonsterItem(DictionaryMainResponse)
        case setItems([DictionaryItem])
        case setFilterItemsItem(DictionaryMainResponse)
        case showSortFilter
        case showFilter
        case setSort(String)
        case setFilter(start: Int, end: Int)
        case setCurrentPage
        case initPage
    }

    public struct State {
        @Pulse var route: Route
        public var items: [DictionaryItem] = []
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
    }

    public var initialState: State
    // map list UseCase
    private let dictionaryMapListUseCase: FetchDictionaryMapListUseCase
    // item list UseCase
    private let dictionaryItemListUseCase: FetchDictionaryItemListUseCase
    // Quest list UseCase
    private let dictionaryQuestListUseCase: FetchDictionaryQuestListUseCase
    // Npc list UseCase
    private let dictionaryNpcListUseCase: FetchDictionaryNpcListUseCase
    private let dictionaryListUseCase: FetchDictionaryMonsterListUseCase
    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let disposeBag = DisposeBag()

    public init(
        type: DictionaryType,
        dictionaryMapListUseCase: FetchDictionaryMapListUseCase,
        dictionaryItemListUseCase: FetchDictionaryItemListUseCase,
        dictionaryQuestListUseCase: FetchDictionaryQuestListUseCase,
        dictionaryNpcListUseCase: FetchDictionaryNpcListUseCase,
        dictionaryListUseCase: FetchDictionaryMonsterListUseCase,
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        self.initialState = State(route: .none, type: type)
        self.dictionaryMapListUseCase = dictionaryMapListUseCase
        self.dictionaryItemListUseCase = dictionaryItemListUseCase
        self.dictionaryQuestListUseCase = dictionaryQuestListUseCase
        self.dictionaryNpcListUseCase = dictionaryNpcListUseCase
        self.dictionaryListUseCase = dictionaryListUseCase
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            switch currentState.type {
                // monster: keyword, minLevel, maxLevel, page, size, sort
                // npc: keyword, page, size, sort
                // quest: keyword, page, size, sort
                // item: keyword, jobId, minLevel, maxLevel, categoryIds, page, size, sort
            /// 몬스터, 아이템을 제외하고는 피그마 상으로는 정렬이 불가능한데, API에는 정렬 옵션이 있음. -> npc, quest,map 도 일단 정렬 옵션 추가
            case .monster:
                return Observable.concat([
                    Observable.just(Mutation.initPage), // 먼저 페이지 초기화
                    dictionaryListUseCase
                        .execute(type: .monster, query: DictionaryListQuery(page: currentState.currentPage, size: 20, sort: nil))
                        .map { Mutation.setListItem($0) }
                ])
            case .npc:
                return Observable.concat([
                    Observable.just(Mutation.initPage),
                    dictionaryNpcListUseCase.execute(keyword: "", page: currentState.currentPage, size: 20, sort: nil)
                .map { Mutation.setListItem($0)}

                ])
            case .quest:
                return Observable.concat([
                    Observable.just(Mutation.initPage),
                    dictionaryQuestListUseCase.execute(keyword: "", page: currentState.currentPage, size: 20, sort: nil)
                .map { Mutation.setListItem($0)}

                ])
            case .item:
                return Observable.concat([
                    Observable.just(Mutation.initPage),
                    dictionaryItemListUseCase.execute(keyword: "", jobId: nil, minLevel: nil, maxLevel: nil, categoryIds: nil, page: currentState.currentPage, size: 20, sort: nil)
                        .map { Mutation.setListItem($0)}
                ])
            case .map:
                return Observable.concat([
                    Observable.just(Mutation.initPage),
                    dictionaryMapListUseCase.execute(keyword: "", page: currentState.currentPage, size: 20, sort: nil)
                        .map { Mutation.setListItem($0)}
                ])
            default:
                return Observable.empty()
            }

        case let .toggleBookmark(id):
            return toggleBookmarkUseCase.execute(id: id, type: currentState.type)
                .map { Mutation.setItems($0) }
        case .sortButtonTapped:
            return Observable.just(.showSortFilter)
        case .filterButtonTapped:
            return Observable.just(.showFilter)
        case let .sortOptionSelected(sort): // 사용자가 필터 선택했을 경우
            return .concat([
                Observable.just(.setSort(sort.sortParameter)),
                Observable.just(Mutation.initPage)

            ])
        case let .filterOptionSelected(startLevel, endLevel):
            return .concat([
                Observable.just(.setFilter(start: startLevel, end: endLevel)),
                Observable.just(Mutation.initPage)
            ])
            .concat(Observable.deferred { [weak self] in
                // 상태 적용 이후 호출
                guard let self = self else { return .empty() }
                return self.fetchListFilter(sort: currentState.sort, startLevel: startLevel, endLevel: endLevel)
            })
        case .setCurrentPage:
            return .concat([
                /* 기존 구조의 문제점
                 현재 상태에서 currentPage == 0
                 .setCurrentPage 전달됨 -> 나중에 reduce에서 currentPage += 1 적용 됨
                 하지만 이 시점에 fetchList는 아직 currentPage == 0인 상태로 실행.
                 개선필요. -> fetchList 액션 추가
                 setCurrentPage 후에 fetchList 호출 함으로써 페이지 올리고, 데이터 불러오기
                 */
                Observable.just(.setCurrentPage)

            ])
        case .fetchList:
            return fetchList(sort: currentState.sort, startLevel: currentState.startLevel, endLevel: currentState.endLevel)
        case .fetchListFilter:
            return fetchListFilter(sort: currentState.sort, startLevel: currentState.startLevel ?? 1, endLevel: currentState.endLevel ?? 200)
        }

    }
    // 필터걸고 난 후 조회
    private func fetchListFilter(sort: String?, startLevel: Int = 1, endLevel: Int = 200) -> Observable<Mutation> {
        switch currentState.type {
        case .monster:
            return dictionaryListUseCase.execute(type: .monster, query: DictionaryListQuery(page: currentState.currentPage, size: 20, sort: sort, minLevel: startLevel, maxLevel: endLevel)
            ).map { Mutation.setFilterMonsterItem($0) }
        case .item:
            return dictionaryItemListUseCase.execute(
                keyword: currentState.keyword,
                jobId: currentState.jobId,
                minLevel: currentState.minLevel,
                maxLevel: currentState.maxLevel,
                categoryIds: currentState.categoryIds,
                page: currentState.currentPage,
                size: 20,
                sort: sort
            ).map { Mutation.setFilterItemsItem($0) }
        default:
            return Observable.empty()
        }
    }

    private func fetchList(sort: String?, startLevel: Int?, endLevel: Int?) -> Observable<Mutation> {
            switch currentState.type {
            case .monster:
                return dictionaryListUseCase.execute(
                    type: .monster,
                    query: DictionaryListQuery(
                        page: currentState.currentPage,
                        size: 20,
                        sort: sort,
                        minLevel: startLevel,
                        maxLevel: endLevel
                    )
                ).map { Mutation.setListItem($0) }

            case .item:
                return dictionaryItemListUseCase.execute(
                    keyword: currentState.keyword,
                    jobId: currentState.jobId,
                    minLevel: currentState.minLevel,
                    maxLevel: currentState.maxLevel,
                    categoryIds: currentState.categoryIds,
                    page: currentState.currentPage,
                    size: 20,
                    sort: sort
                ).map { Mutation.setListItem($0) }
            case .map: // 몬스터, 아이템을 제외하고는 기본 ASC 정렬
                return dictionaryMapListUseCase.execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                    .map { Mutation.setListItem($0)}
            case .npc:
                return dictionaryNpcListUseCase.execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                    .map { Mutation.setListItem($0)}
            case .quest:
                return dictionaryQuestListUseCase.execute(keyword: currentState.keyword ?? "", page: currentState.currentPage, size: 20, sort: "ASC")
                    .map { Mutation.setListItem($0)}
            default:
                return Observable.empty()
            }
        }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setFilterMonsterItem(items):
            newState.listItems = items.contents
        case let .setFilterItemsItem(items):
            newState.listItems = items.contents
        case let .setItems(items):
            newState.items = items
        case .showSortFilter:
            newState.route = .sort(newState.type)
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setListItem(items):
            newState.listItems.append(contentsOf: items.contents)
        case let .setSort(sort):
            newState.sort = sort
        case let .setFilter(startLevel, endLevel):
            newState.startLevel = startLevel
            newState.endLevel = endLevel
        case .setCurrentPage:
            newState.currentPage += 1
        case .initPage:
            newState.currentPage = 0
        }
        return newState
    }
}
