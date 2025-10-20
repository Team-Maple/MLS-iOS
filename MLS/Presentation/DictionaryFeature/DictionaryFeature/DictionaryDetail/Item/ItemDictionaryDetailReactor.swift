import DomainInterface

import ReactorKit

public final class ItemDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter(DictionaryType)
    }

    public let dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase
    public let dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase

    public struct State {
        @Pulse var route: Route = .none
        var itemDetailInfo: DictionaryDetailItemResponse
        var type: DictionaryType = .item
        var monsters: [DictionaryDetailItemDropMonsterResponse]
        var id = 0
    }

    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
    }

    public enum Mutation {
        case showFilter
        case setDetailData(DictionaryDetailItemResponse)
        case setDetailDropMonsterData([DictionaryDetailItemDropMonsterResponse])
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    public init(dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase, dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase, id: Int) {
        self.initialState = .init(itemDetailInfo: DictionaryDetailItemResponse(itemId: nil, nameKr: nil, nameEn: nil, descriptionText: nil, imgUrl: nil, npcPrice: nil, itemType: nil, categoryHierachy: nil, availableJobs: nil, requiredStats: nil, equipmentStats: nil, scrollDetail: nil, isBookmarked: nil), type: .item, monsters: [], id: id)
        self.dictionaryDetailItemUseCase = dictionaryDetailItemUseCase
        self.dictionaryDetailItemDropMonsterUseCase = dictionaryDetailItemDropMonsterUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return Observable.just(.showFilter)
        case .viewWillAppear:
            return .merge([
                dictionaryDetailItemUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: nil).map {.setDetailDropMonsterData($0)}
            ])
        case let .selectFilter(type):
            switch type {
            case .mostDrop:// 드롭률 내림차순
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["dropRate", "desc"]).map {.setDetailDropMonsterData($0)}
            case .levelDESC:
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["level", "desc"]).map {.setDetailDropMonsterData($0)}
            case .levelASC:
                return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: ["level", "asc"]).map {.setDetailDropMonsterData($0)}
            default:
                return Observable.empty()
            }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setDetailData(data):
            newState.itemDetailInfo = data
        case let .setDetailDropMonsterData(data):
            newState.monsters = data
        }

        return newState
    }
}
