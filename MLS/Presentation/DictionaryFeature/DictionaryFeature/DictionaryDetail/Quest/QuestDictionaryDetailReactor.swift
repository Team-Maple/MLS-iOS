import DomainInterface

import ReactorKit

public final class QuestDictionaryDetailReactor: Reactor {
    enum QuestType {
        case previous
        case current
        case next
    }

    struct QuestInfo: Equatable {
        let quest: Quest
        let type: QuestType
    }

    public enum Route {
        case none
        case filter(DictionaryType)
        case detail(type: DictionaryType, id: Int)
    }

    public enum Action {
        case viewWillAppear
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
        case questTapped(index: Int)
        case infoTapped(type: DictionaryType, id: Int)
    }

    public enum Mutation {
        case toNavigate(Route)
        case setDetailData(DictionaryDetailQuestResponse)
        case setLinkedQuests(DictionaryDetailQuestLinkedQuestsResponse)
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryDetailQuestResponse?)
    }

    public struct State {
        @Pulse var route: Route = .none
        var type: DictionaryType = .quest
        var id: Int
        var detailInfo: DictionaryDetailQuestResponse
        var linkedQuestInfo: DictionaryDetailQuestLinkedQuestsResponse
        var totalQuest: [QuestInfo]
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailQuestResponse?
    }

    private let dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase
    private let dictionaryDetailQuestLinkedQuestUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public var initialState: State
    private let disposeBag = DisposeBag()

    public init(
        dictionaryDetailQuestUseCase: FetchDictionaryDetailQuestUseCase,
        dictionaryDetailQuestLinkedQuestUseCase: FetchDictionaryDetailQuestLinkedQuestsUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.dictionaryDetailQuestUseCase = dictionaryDetailQuestUseCase
        self.dictionaryDetailQuestLinkedQuestUseCase = dictionaryDetailQuestLinkedQuestUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.initialState = .init(
            id: id,
            detailInfo: .init(
                questId: nil,
                titlePrefix: nil,
                nameKr: nil,
                nameEn: nil,
                iconUrl: nil,
                questType: nil,
                minLevel: nil,
                maxLevel: nil,
                requiredMesoStart: nil,
                startNpcId: nil,
                startNpcName: nil,
                endNpcId: nil,
                endNpcName: nil,
                reward: nil,
                rewardItems: nil,
                requirements: nil,
                allowedJobs: nil,
                bookmarkId: nil
            ),
            linkedQuestInfo: .init(previousQuests: nil, nextQuests: nil), totalQuest: []
        )
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailQuestUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailQuestLinkedQuestUseCase.execute(id: currentState.id).map { .setLinkedQuests($0) }
            ])

        case let .toggleBookmark(isSelected):
            guard let questId = currentState.detailInfo.questId else { return .empty() }

            let saveDeleted: Observable<Mutation> = isSelected
                ? .just(.setLastDeletedBookmark(currentState.detailInfo))
                : .just(.setLastDeletedBookmark(nil))

            return saveDeleted.concat(
                setBookmarkUseCase.execute(
                    bookmarkId: currentState.detailInfo.bookmarkId ?? questId,
                    isBookmark: isSelected ? .delete : .set(.quest)
                )
                .andThen(
                    dictionaryDetailQuestUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) }
                )
            )

        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark,
                  let questId = lastDeleted.questId else { return .empty() }

            return setBookmarkUseCase.execute(
                bookmarkId: questId,
                isBookmark: .set(.quest)
            )
            .andThen(
                Observable.concat([
                    dictionaryDetailQuestUseCase.execute(id: currentState.id)
                        .map { .setDetailData($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        case let .questTapped(index):
            let tappedQuestInfo = currentState.totalQuest[index]
            guard let id = tappedQuestInfo.quest.questId,
                  tappedQuestInfo.type != .current else { return .empty() }
            return .just(.toNavigate(.detail(type: .quest, id: id)))
        case let .infoTapped(type: type, id: id):
            return .just(.toNavigate(.detail(type: type, id: id)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailData(data):
            newState.detailInfo = data
            newState.totalQuest = mergeTotalQuests(
                detailInfo: data,
                linkedInfo: state.linkedQuestInfo
            )
        case let .setLinkedQuests(data):
            newState.linkedQuestInfo = data
            newState.totalQuest = mergeTotalQuests(
                detailInfo: state.detailInfo,
                linkedInfo: data
            )
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setLastDeletedBookmark(data):
            newState.lastDeletedBookmark = data
        case let .toNavigate(route):
            newState.route = route
        }
        return newState
    }
}

extension QuestDictionaryDetailReactor {
    private func mergeTotalQuests(
        detailInfo: DictionaryDetailQuestResponse,
        linkedInfo: DictionaryDetailQuestLinkedQuestsResponse
    ) -> [QuestInfo] {
        var quests: [QuestInfo] = []

        if let previous = linkedInfo.previousQuests {
            let mapped = previous.map { QuestInfo(quest: $0, type: .previous) }
            quests.append(contentsOf: mapped)
        }

        if let currentId = detailInfo.questId {
            let currentQuest = Quest(
                questId: currentId,
                name: detailInfo.nameKr ?? "",
                minLevel: detailInfo.minLevel,
                maxLevel: detailInfo.maxLevel,
                iconUrl: detailInfo.iconUrl
            )
            quests.append(QuestInfo(quest: currentQuest, type: .current))
        }

        if let next = linkedInfo.nextQuests {
            let mapped = next.map { QuestInfo(quest: $0, type: .next) }
            quests.append(contentsOf: mapped)
        }

        return quests
    }
}
