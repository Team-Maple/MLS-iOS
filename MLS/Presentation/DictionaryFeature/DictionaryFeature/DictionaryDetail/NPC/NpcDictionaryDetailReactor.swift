import DomainInterface

import ReactorKit

public final class NpcDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter(DictionaryType)
    }

    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
    }

    public enum Mutation {
        case showFilter
        case setDetailData(DictionaryDetailNpcResponse)
        case setDetailMaps([DictionaryDetailMonsterMapResponse])
        case setDetailQuests([DictionaryDetailNpcQuestResponse])
    }
    public struct Info: Equatable {
        var name: String
        var imgUrl: String?
        var subText: String
    }

    public struct State {
        @Pulse var route: Route = .none
        var info = Info(name: "", subText: "")
        var isBookmarked: Bool = false
        var type: DictionaryType = .npc
        var maps: [DictionaryDetailMonsterMapResponse]
        var quests: [DictionaryDetailNpcQuestResponse]
        var id = 0
    }

    public let dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase
    public let dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase
    public let dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase

    public var initialState: State
    private let disposBag = DisposeBag()

    public init(dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase, dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase, dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase, id: Int) {

        initialState = State(type: .npc, maps: [], quests: [], id: id)
        self.dictionaryDetailNpcUseCase = dictionaryDetailNpcUseCase
        self.dictionaryDetailNpcQuestUseCase = dictionaryDetailNpcQuestUseCase
        self.dictionaryDetailNpcMapUseCase = dictionaryDetailNpcMapUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return Observable.just(.showFilter)
        case .viewWillAppear:
            return .concat([
                dictionaryDetailNpcUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailNpcMapUseCase.execute(id: currentState.id).map {.setDetailMaps($0)},
                dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: nil).map {.setDetailQuests($0)}
            ])
        case let .selectFilter(type):
            switch type {
            case .levelHighest:
                return dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: ["maxLevel", "desc"]).map {.setDetailQuests($0)}
            case .levelLowest:
                return dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: ["minLevel", "asc"]).map {.setDetailQuests($0)}
            default:
                return .empty()
            }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setDetailData(data):
            newState.info.name = data.nameKr
            newState.info.subText = data.nameEn
            newState.info.imgUrl = data.iconUrlDetail
            newState.isBookmarked = data.bookmarkId != nil
        case let .setDetailMaps(data):
            newState.maps = data
        case let .setDetailQuests(data):
            newState.quests = data
        }
        return newState
    }
}
