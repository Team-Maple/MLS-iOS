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
        case bookmarkError
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailQuestResponse)
        case delete(DictionaryDetailQuestResponse)
        case undo
    }

    public enum Action {
        case viewWillAppear
        case toggleBookmark
        case undoLastDeletedBookmark
        case questTapped(index: Int)
        case infoTapped(type: DictionaryType, id: Int)
    }

    public enum Mutation {
        case navigatTo(Route)
        case setDetailData(DictionaryDetailQuestResponse)
        case setLinkedQuests(DictionaryDetailQuestLinkedQuestsResponse)
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryDetailQuestResponse?)
        case setEvent(UIEvent)
    }

    public struct State {
        @Pulse var event: UIEvent = .none
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
                questId: 0,
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

        case .toggleBookmark:
            return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case let .questTapped(index):
            let tappedQuestInfo = currentState.totalQuest[index]
            guard let id = tappedQuestInfo.quest.questId,
                  tappedQuestInfo.type != .current else { return .empty() }
            return .just(.navigatTo(.detail(type: .quest, id: id)))

        case let .infoTapped(type: type, id: id):
            return .just(.navigatTo(.detail(type: type, id: id)))
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
        case let .navigatTo(route):
            newState.route = route
        case let .setEvent(event):
            newState.event = event
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

        let currentQuest = Quest(
            questId: detailInfo.questId,
            name: detailInfo.nameKr ?? "",
            minLevel: detailInfo.minLevel,
            maxLevel: detailInfo.maxLevel,
            iconUrl: detailInfo.iconUrl
        )
        quests.append(QuestInfo(quest: currentQuest, type: .current))

        if let next = linkedInfo.nextQuests {
            let mapped = next.map { QuestInfo(quest: $0, type: .next) }
            quests.append(contentsOf: mapped)
        }

        return quests
    }
}

private extension QuestDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var quest = currentState.detailInfo
        let isSelected = quest.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: isSelected ? quest.bookmarkId ?? quest.questId : quest.questId,
            isBookmark: isSelected ? .delete : .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            quest.bookmarkId = newBookmarkId
            let event: UIEvent = isSelected ? .delete(quest) : .add(quest)
            let eventMutation = Observable.just(Mutation.setEvent(event))

            let refresh = self.dictionaryDetailQuestUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var quest = currentState.detailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: quest.questId,
            isBookmark: .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            quest.bookmarkId = newBookmarkId
            let eventMutation = Observable.just(Mutation.setEvent(.add(quest)))
            let refresh = self.dictionaryDetailQuestUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
