import DomainInterface

import ReactorKit

// MARK: - Reactor
public final class ItemDictionaryDetailReactor: Reactor {
    // MARK: Type
    public enum Route {
        case none
        case filter(DictionaryType)
    }

    // MARK: Action
    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
    }

    // MARK: Mutation
    public enum Mutation {
        case showFilter
        case setDetailData(DictionaryDetailItemResponse)
        case setDetailDropMonsterData([DictionaryDetailItemDropMonsterResponse])
        case setBookmark(DictionaryDetailItemResponse)
        case setLastDeletedBookmark(DictionaryDetailItemResponse?)
        case setLoginState(Bool)
    }
    
    // MARK: State
    public struct State {
        @Pulse var route: Route = .none
        var itemDetailInfo: DictionaryDetailItemResponse
        var type: DictionaryType = .item
        var monsters: [DictionaryDetailItemDropMonsterResponse]
        var id: Int
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailItemResponse?
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    private let dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase
    private let dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    // MARK: Init
    public init(
        dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase,
        dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.dictionaryDetailItemUseCase = dictionaryDetailItemUseCase
        self.dictionaryDetailItemDropMonsterUseCase = dictionaryDetailItemDropMonsterUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.initialState = .init(
            itemDetailInfo: DictionaryDetailItemResponse(
                itemId: nil, nameKr: nil, nameEn: nil, descriptionText: nil,
                imgUrl: nil, npcPrice: nil, itemType: nil, categoryHierachy: nil,
                availableJobs: nil, requiredStats: nil, equipmentStats: nil,
                scrollDetail: nil, bookmarkId: nil
            ),
            type: .item,
            monsters: [],
            id: id
        )
    }

    // MARK: Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return .just(.showFilter)
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailItemUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: nil).map { .setDetailDropMonsterData($0) }
            ])
        case let .selectFilter(type):
            switch type {
            case .mostDrop:
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["dropRate", "desc"]).map { .setDetailDropMonsterData($0) }
            case .levelDESC:
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["level", "desc"]).map { .setDetailDropMonsterData($0) }
            case .levelASC:
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["level", "asc"]).map { .setDetailDropMonsterData($0) }
            default:
                return .empty()
            }
        case let .toggleBookmark(isSelected):
            guard let itemId = currentState.itemDetailInfo.itemId else { return .empty() }

            let saveDeleted: Observable<Mutation> = isSelected
                ? .just(.setLastDeletedBookmark(currentState.itemDetailInfo))
                : .just(.setLastDeletedBookmark(nil))

            return saveDeleted.concat(
                setBookmarkUseCase.execute(
                    bookmarkId: currentState.itemDetailInfo.bookmarkId ?? itemId,
                    isBookmark: isSelected ? .delete : .set(.item)
                )
                .andThen(
                    dictionaryDetailItemUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) }
                )
            )
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark,
                  let itemId = lastDeleted.itemId else { return .empty() }

            return setBookmarkUseCase.execute(
                bookmarkId: itemId,
                isBookmark: .set(.item)
            )
            .andThen(
                Observable.concat([
                    dictionaryDetailItemUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        }
    }

    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setDetailData(data):
            newState.itemDetailInfo = data
        case let .setDetailDropMonsterData(data):
            newState.monsters = data
        case let .setBookmark(item):
            newState.itemDetailInfo = item
        case let .setLastDeletedBookmark(item):
            newState.lastDeletedBookmark = item
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        }
        return newState
    }
}
