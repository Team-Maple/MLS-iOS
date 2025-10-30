import DomainInterface

import ReactorKit

final class QuestDictionaryDetailReactor: Reactor {

    public struct State {
        var type: DictionaryItemType

        var detailInfo: DictionaryDetailQuestResponse
        var linkedQuestInfo: DictionaryDetailQuestLinkedQuestsResponse

        var id = 0
    }

    public let dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase
    public let dictionaryDetailQuestLinkedQuestUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase

    public enum Action {
        case viewWillAppear
    }

    public enum Mutation {
        case setDetailData(DictionaryDetailQuestResponse)
        case setLinkedQuests(DictionaryDetailQuestLinkedQuestsResponse)
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    public init(dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase, dictionaryDetailQuestLinkedQuestsUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase, id: Int) {
        self.initialState = .init(type: .quest, detailInfo: DictionaryDetailQuestResponse(questId: nil, titlePrefix: nil, nameKr: nil, nameEn: nil, iconUrl: nil, questType: nil, minLevel: nil, maxLevel: nil, requiredMesoStart: nil, startNpcId: nil, startNpcName: nil, endNpcId: nil, endNpcName: nil, reward: nil, rewardItems: nil, requirements: nil, allowedJobs: nil, bookmarkId: nil), linkedQuestInfo: DictionaryDetailQuestLinkedQuestsResponse(previousQuests: nil, nextQuests: nil), id: id)
        self.dictionaryDetailQuestUseCase = dictionaryDetailQuestUseCase
        self.dictionaryDetailQuestLinkedQuestUseCase = dictionaryDetailQuestLinkedQuestsUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                dictionaryDetailQuestUseCase.execute(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailQuestLinkedQuestUseCase.execute(id: currentState.id).map {.setLinkedQuests( $0 )
                }

            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailData(data):
            newState.detailInfo = data
        case let .setLinkedQuests(data):
            newState.linkedQuestInfo = data
        }
        return newState
    }
}
