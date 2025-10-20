import DomainInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter(DictionaryType)
    }
    public enum Action {
        case filterButtonTapped
        case viewWillAppear
    }

    public enum Mutation {
        case showFilter
        case setDetailData(DictionaryDetailMapResponse)
        case setDetailSpawnMonsters([DictionaryDetailMapSpawnMonsterResponse])
        case setDetailNpc([DictionaryDetailMapNpcResponse])
    }

    public let dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase
    public let dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase
    public let dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase

    public struct State {
        @Pulse var route: Route = .none
        var mapDetailInfo: DictionaryDetailMapResponse
        var spawnMonsters: [DictionaryDetailMapSpawnMonsterResponse]
        var npcs: [DictionaryDetailMapNpcResponse]
        var type: DictionaryType = .map
        var id = 0
    }

    public var initialState: State
    private let disposBag = DisposeBag()

    public init(dictionaryDetailMapUseCase: FetchDictionaryDetailMapUseCase, dictionaryDetailMapSpawnMonsterUseCase: FetchDictionaryDetailMapSpawnMonsterUseCase, dictionaryDetailMapNpcUseCase: FetchDictionaryDetailMapNpcUseCase, id: Int) {
        initialState = State(mapDetailInfo: DictionaryDetailMapResponse(mapId: nil, nameKr: nil, nameEn: nil, regionName: nil, detailName: nil, topRegionName: nil, mapUrl: nil, iconUrl: nil, isBookmarked: nil), spawnMonsters: [], npcs: [], type: .map, id: id)

        self.dictionaryDetailMapUseCase = dictionaryDetailMapUseCase
        self.dictionaryDetailMapSpawnMonsterUseCase = dictionaryDetailMapSpawnMonsterUseCase
        self.dictionaryDetailMapNpcUseCase = dictionaryDetailMapNpcUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return Observable.just(.showFilter)
        case .viewWillAppear:
            return .merge([
                dictionaryDetailMapUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailMapSpawnMonsterUseCase.execute(id: currentState.id).map {.setDetailSpawnMonsters($0)},
                dictionaryDetailMapNpcUseCase.execute(id: currentState.id).map {.setDetailNpc($0)}
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setDetailData(data):
            newState.mapDetailInfo = data
        case let .setDetailSpawnMonsters(data):
            newState.spawnMonsters = data
        case let .setDetailNpc(data):
            newState.npcs = data
        }
        return newState
    }
}
