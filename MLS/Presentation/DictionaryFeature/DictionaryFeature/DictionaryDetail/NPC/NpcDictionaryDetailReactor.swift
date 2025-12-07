import DomainInterface

import ReactorKit

public final class NpcDictionaryDetailReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case filter([SortType])
        case detail(type: DictionaryType, id: Int)
    }

    // MARK: - Action
    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
        case mapTapped(index: Int)
        case questTapped(index: Int)
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
        case setDetailData(DictionaryDetailNpcResponse)
        case setDetailMaps([DictionaryDetailMonsterMapResponse])
        case setDetailQuests([DictionaryDetailNpcQuestResponse])
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryDetailNpcResponse?)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route = .none
        var npcDetailInfo: DictionaryDetailNpcResponse
        var type: DictionaryType = .npc
        var maps: [DictionaryDetailMonsterMapResponse]
        var quests: [DictionaryDetailNpcQuestResponse]
        var questFilter: [SortType] {
            type.detailTypes[0].sortFilter
        }
        var id: Int
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailNpcResponse?
    }

    // MARK: - UseCases
    private let dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase
    private let dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase
    private let dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public var initialState: State
    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase,
        dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase,
        dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.dictionaryDetailNpcUseCase = dictionaryDetailNpcUseCase
        self.dictionaryDetailNpcQuestUseCase = dictionaryDetailNpcQuestUseCase
        self.dictionaryDetailNpcMapUseCase = dictionaryDetailNpcMapUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.initialState = State(
            npcDetailInfo: DictionaryDetailNpcResponse(
                npcId: 0, nameKr: "", nameEn: "", iconUrlDetail: nil, bookmarkId: nil
            ),
            maps: [],
            quests: [],
            id: id
        )
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return .just(.toNavigate(.filter(currentState.questFilter)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailNpcUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailNpcMapUseCase.execute(id: currentState.id).map { .setDetailMaps($0) },
                dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: nil).map { .setDetailQuests($0) }
            ])
        case let .selectFilter(type):
            switch type {
            case .levelHighest:
                return dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: ["maxLevel", "desc"]).map { .setDetailQuests($0) }
            case .levelLowest:
                return dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: ["minLevel", "asc"]).map { .setDetailQuests($0) }
            default:
                return .empty()
            }

        case let .toggleBookmark(isSelected):
            let npcId = currentState.npcDetailInfo.npcId

            let saveDeleted: Observable<Mutation> = isSelected
                ? .just(.setLastDeletedBookmark(currentState.npcDetailInfo))
                : .just(.setLastDeletedBookmark(nil))

            return saveDeleted.concat(
                setBookmarkUseCase.execute(
                    bookmarkId: currentState.npcDetailInfo.bookmarkId ?? npcId,
                    isBookmark: isSelected ? .delete : .set(.npc)
                )
                .andThen(
                    dictionaryDetailNpcUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) }
                )
            )

        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
            let npcId = lastDeleted.npcId

            return setBookmarkUseCase.execute(
                bookmarkId: npcId,
                isBookmark: .set(.npc)
            )
            .andThen(
                Observable.concat([
                    dictionaryDetailNpcUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case .mapTapped(index: let index):
            return .just(.toNavigate(.detail(type: .map, id: currentState.maps[index].mapId)))
        case .questTapped(index: let index):
            return .just(.toNavigate(.detail(type: .quest, id: currentState.quests[index].questId)))
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case let .setDetailData(data):
            newState.npcDetailInfo = data
        case let .setDetailMaps(data):
            newState.maps = data
        case let .setDetailQuests(data):
            newState.quests = data
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setLastDeletedBookmark(map):
            newState.lastDeletedBookmark = map
        }
        return newState
    }
}
