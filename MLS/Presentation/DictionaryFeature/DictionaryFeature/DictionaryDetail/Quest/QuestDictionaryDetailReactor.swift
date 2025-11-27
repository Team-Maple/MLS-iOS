import DomainInterface

import ReactorKit

public final class QuestDictionaryDetailReactor: Reactor {
    public enum Route {
        case none
        case filter(DictionaryType)
        case detail(id: Int)
    }

    public enum Action {
        case viewWillAppear
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
        case questTapped(index: Int)
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
            linkedQuestInfo: .init(previousQuests: nil, nextQuests: nil)
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
            if let previous = currentState.linkedQuestInfo.previousQuests, !previous.isEmpty {
                if index == 0, let questId = previous.first?.questId {
                    return .just(.toNavigate(.detail(id: questId)))
                } else if index == 1, let next = currentState.linkedQuestInfo.nextQuests?.first?.questId {
                    return .just(.toNavigate(.detail(id: next)))
                }
            } else {
                if let next = currentState.linkedQuestInfo.nextQuests, index == 0, let questId = next.first?.questId {
                    return .just(.toNavigate(.detail(id: questId)))
                }
            }
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailData(data):
            newState.detailInfo = data
        case let .setLinkedQuests(data):
            newState.linkedQuestInfo = data
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setLastDeletedBookmark(data):
            newState.lastDeletedBookmark = data
        case .toNavigate(let route):
            newState.route = route
        }
        return newState
    }
}
