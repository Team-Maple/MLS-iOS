import DomainInterface

import ReactorKit

public final class MonsterDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter(DictionaryType)
    }
    /// UI 구현을 위한 임시 모델(몬스터 상세정보)
    struct TabMenu: Equatable {
        var infos: [Info]
        var maps: [DictionaryDetailMonsterMapResponse]
        var items: [DictionaryDetailMonsterDropItemResponse]

        static func == (lhs: TabMenu, rhs: TabMenu) -> Bool {
            return lhs.infos == rhs.infos &&
            lhs.maps == rhs.maps &&
            lhs.items == rhs.items
        }
    }

    public struct Info: Equatable {
        var name: String
        var desc: String
    }
    // 임시 모델
    public struct Map: Equatable {
        var mapName: String
        var detailName: String
        var maxSpawnCount: Int
        var iconUrl: String
    }
    public struct Item: Equatable {
        var itemName: String
        var dropRate: Double
        var imageUrl: String
        var itemLevel: Int
    }

    public enum Action {
        case filterButtonTapped(DictionaryType)
        case viewWillAppear
    }

    public enum Mutation {
        case showFilter(DictionaryType)
        case setDetailData(DictionaryDetailMonsterResponse)
        case setDetailDropItemData([DictionaryDetailMonsterDropItemResponse])
        case setDetailMapData([DictionaryDetailMonsterMapResponse])
    }

    public struct State {
        @Pulse var route: Route = .none
        var type: DictionaryType = .item
        var id = 0
        var name = "슈미의 의뢰"
        var level = 0
        var imageUrl = ""
        var subTextLabel = "LV.21"
        var tags: Effectiveness = Effectiveness(fire: nil, lightning: nil, poison: nil, holy: nil, ice: nil, physical: nil)
        var menus = TabMenu(
            infos: [],
            maps: [],
            items: []
        )
    }

    public let dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase
    public let dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase
    public let dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase

    public var initialState: State
    private let disposBag = DisposeBag()

    public init(dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase, dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase, dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase, id: Int) {
        self.initialState = State(type: .monster, id: id)
        self.dictionaryDetailMonsterUseCase = dictionaryDetailMonsterUseCase
        self.dictionaryDetailMonsterDropItemUseCase = dictionaryDetailMonsterDropItemUseCase
        self.dictionaryDetailMonsterMapUseCase = dictionaryDetailMonsterMapUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .filterButtonTapped(type):
            return Observable.just(.showFilter(type))
        case .viewWillAppear:
            return .concat([
                dictionaryDetailMonsterUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id).map {.setDetailDropItemData($0)},
                dictionaryDetailMonsterMapUseCase.execute(id: currentState.id).map {.setDetailMapData($0)}
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .showFilter(type):
            newState.type = type
            newState.route = .filter(type)
        case let .setDetailData(data):
            newState.name = data.nameKr
            newState.level = data.level
            var infos: [Info] = []
            infos.append(.init(name: "HP", desc: "\(data.hp)"))
            infos.append(.init(name: "MP", desc: "\(data.mp)"))
            infos.append(.init(name: "EXP", desc: "\(data.exp)"))
            infos.append(.init(name: "물리방어력", desc: "\(data.physicalDefense)"))
            infos.append(.init(name: "마법방어력", desc: "\(data.magicDefense)"))
            if let typeEffectiveness = data.typeEffectiveness {
                newState.tags = typeEffectiveness
            }
            newState.menus.infos = infos
        case let .setDetailDropItemData(data):
            newState.menus.items = data
        case let .setDetailMapData(data):
            newState.menus.maps = data
        }
        return newState
    }
}
