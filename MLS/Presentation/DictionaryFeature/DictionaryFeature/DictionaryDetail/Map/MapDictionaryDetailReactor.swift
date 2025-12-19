import DomainInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter([SortType])
        case detail(type: DictionaryType, id: Int)
        case bookmarkError
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailMapResponse)
        case delete(DictionaryDetailMapResponse)
        case undo
    }

    public enum Action {
        case monsterFilterButtonTapped
        case viewWillAppear
        case toggleBookmark
        case undoLastDeletedBookmark
        case monsterTapped(index: Int)
        case npcTapped(index: Int)
        case selectFilter(SortType)
    }

    public enum Mutation {
        case navigatTo(Route)
        case setDetailData(DictionaryDetailMapResponse)
        case setDetailSpawnMonsters([DictionaryDetailMapSpawnMonsterResponse])
        case setDetailNpc([DictionaryDetailMapNpcResponse])
        case setBookmark(DictionaryDetailMapResponse)
        case setLastDeletedBookmark(DictionaryDetailMapResponse?)
        case setLoginState(Bool)
        case setEvent(UIEvent)
    }

    public let dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase
    public let dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase
    public let dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public struct State {
        @Pulse var event: UIEvent = .none
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
                mapId: 0,
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
            return Observable.just(.navigatTo(.filter(currentState.monsterFilter)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailMapUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailMapSpawnMonsterUseCase.execute(id: currentState.id, sort: nil).map {.setDetailSpawnMonsters($0)},
                dictionaryDetailMapNpcUseCase.execute(id: currentState.id).map {.setDetailNpc($0)}
            ])
        case .toggleBookmark:
           return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case let .selectFilter(type):
            return dictionaryDetailMapSpawnMonsterUseCase.execute(id: currentState.id, sort: type.sortParameter).map { .setDetailSpawnMonsters($0) }

        case .monsterTapped(index: let index):
            guard let id = currentState.spawnMonsters[index].monsterId else { return .empty() }

            return .just(.navigatTo(.detail(type: .monster, id: id)))
        case .npcTapped(index: let index):
            guard let id = currentState.npcs[index].npcId else { return .empty() }
            return .just(.navigatTo(.detail(type: .npc, id: id)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigatTo(let route):
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
        case let .setEvent(event):
            newState.event = event
        }
        return newState
    }
}

private extension MapDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var map = currentState.mapDetailInfo
        let isSelected = map.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: isSelected ? map.bookmarkId ?? map.mapId : map.mapId,
            isBookmark: isSelected ? .delete : .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            map.bookmarkId = newBookmarkId
            let event: UIEvent = isSelected ? .delete(map) : .add(map)
            let eventMutation = Observable.just(Mutation.setEvent(event))

            let refresh = self.dictionaryDetailMapUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var map = currentState.mapDetailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: map.mapId,
            isBookmark: .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            map.bookmarkId = newBookmarkId
            let eventMutation = Observable.just(Mutation.setEvent(.add(map)))
            let refresh = self.dictionaryDetailMapUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
