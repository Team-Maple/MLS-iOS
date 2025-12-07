import DomainInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter([SortType])
        case detail(type: DictionaryType, id: Int)
    }
    public enum Action {
        case monsterFilterButtonTapped
        case viewWillAppear
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
        case monsterTapped(index: Int)
        case npcTapped(index: Int)
        case selectFilter(SortType)
    }

    public enum Mutation {
        case toNavigate(Route)
        case setDetailData(DictionaryDetailMapResponse)
        case setDetailSpawnMonsters([DictionaryDetailMapSpawnMonsterResponse])
        case setDetailNpc([DictionaryDetailMapNpcResponse])
        case setBookmark(DictionaryDetailMapResponse)
        case setLastDeletedBookmark(DictionaryDetailMapResponse?)
        case setLoginState(Bool)
    }

    public let dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase
    public let dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase
    public let dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public struct State {
        @Pulse var route: Route = .none
        var mapDetailInfo: DictionaryDetailMapResponse
        var spawnMonsters: [DictionaryDetailMapSpawnMonsterResponse]
        var npcs: [DictionaryDetailMapNpcResponse]
        var type: DictionaryType = .map
        var monsterFilter: [SortType] {
            type.detailTypes[0].sortFilter
        }
        var id = 0
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailMapResponse?
    }

    public var initialState: State
    private let disposBag = DisposeBag()

    public init(
        dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase,
        dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase,
        dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        initialState = State(
            mapDetailInfo: DictionaryDetailMapResponse(
                mapId: nil,
                nameKr: nil,
                nameEn: nil,
                regionName: nil,
                detailName: nil,
                topRegionName: nil,
                mapUrl: nil,
                iconUrl: nil,
                bookmarkId: nil
            ),
            spawnMonsters: [],
            npcs: [],
            type: .map,
            id: id
        )

        self.dictionaryDetailMapUseCase = dictionaryDetailMapUseCase
        self.dictionaryDetailMapSpawnMonsterUseCase = dictionaryDetailMapSpawnMonsterUseCase
        self.dictionaryDetailMapNpcUseCase = dictionaryDetailMapNpcUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .monsterFilterButtonTapped:
            return Observable.just(.toNavigate(.filter(currentState.monsterFilter)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailMapUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailMapSpawnMonsterUseCase.execute(id: currentState.id, sort: nil).map {.setDetailSpawnMonsters($0)},
                dictionaryDetailMapNpcUseCase.execute(id: currentState.id).map {.setDetailNpc($0)}
            ])
        case let .toggleBookmark(isSelected):
            guard let itemId = currentState.mapDetailInfo.mapId else { return .empty() }

            let saveDeleted: Observable<Mutation> = isSelected
                ? .just(.setLastDeletedBookmark(currentState.mapDetailInfo))
                : .just(.setLastDeletedBookmark(nil))

            return saveDeleted.concat(
                setBookmarkUseCase.execute(
                    bookmarkId: currentState.mapDetailInfo.bookmarkId ?? itemId,
                    isBookmark: isSelected ? .delete : .set(.map)
                )
                .andThen(
                    dictionaryDetailMapUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) }
                )
            )
        case let .selectFilter(type):
                return dictionaryDetailMapSpawnMonsterUseCase.execute(id: currentState.id, sort: ["maxSpawnCount", "asc"]).map { .setDetailSpawnMonsters($0) }
        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark,
                  let mapId = lastDeleted.mapId else { return .empty() }

            return setBookmarkUseCase.execute(
                bookmarkId: mapId,
                isBookmark: .set(.map)
            )
            .andThen(
                Observable.concat([
                    dictionaryDetailMapUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case .monsterTapped(index: let index):
            guard let id = currentState.spawnMonsters[index].monsterId else { return .empty() }
            return .just(.toNavigate(.detail(type: .monster, id: id)))
        case .npcTapped(index: let index):
            guard let id = currentState.npcs[index].npcId else { return .empty() }
            return .just(.toNavigate(.detail(type: .npc, id: id)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case let .setDetailData(data):
            newState.mapDetailInfo = data
        case let .setDetailSpawnMonsters(data):
            newState.spawnMonsters = data
        case let .setDetailNpc(data):
            newState.npcs = data
        case let .setBookmark(map):
            newState.mapDetailInfo = map
        case let .setLastDeletedBookmark(map):
            newState.lastDeletedBookmark = map
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        }
        return newState
    }
}
