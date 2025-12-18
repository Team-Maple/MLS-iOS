import DomainInterface

import ReactorKit

public final class NpcDictionaryDetailReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case filter([SortType])
        case detail(type: DictionaryType, id: Int)
        case bookmarkError
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailNpcResponse)
        case delete(DictionaryDetailNpcResponse)
        case undo
    }

    // MARK: - Action
    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark
        case undoLastDeletedBookmark
        case mapTapped(index: Int)
        case questTapped(index: Int)
    }

    // MARK: - Mutation
    public enum Mutation {
        case navigatTo(Route)
        case setDetailData(DictionaryDetailNpcResponse)
        case setDetailMaps([DictionaryDetailMonsterMapResponse])
        case setDetailQuests([DictionaryDetailNpcQuestResponse])
        case setLoginState(Bool)
        case setLastDeletedBookmark(DictionaryDetailNpcResponse?)
        case setEvent(UIEvent)
    }

    // MARK: - State
    public struct State {
        @Pulse var event: UIEvent = .none
        @Pulse var route: Route = .none
        var npcDetailInfo: DictionaryDetailNpcResponse
        var type: DictionaryType = .npc
        var maps: [DictionaryDetailMonsterMapResponse]
        var quests: [DictionaryDetailNpcQuestResponse]
        var questFilter: [SortType] {
            type.detailTypes[0].sortFilter
        }
        var id: Int
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailNpcResponse?
    }

    // MARK: - UseCases
    private let dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase
    private let dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase
    private let dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public var initialState: State
    private let disposeBag = DisposeBag()

    // MARK: - Init
    public init(
        dictionaryDetailNpcUseCase: FetchDictionaryDetailNpcUseCase,
        dictionaryDetailNpcQuestUseCase: FetchDictionaryDetailNpcQuestUseCase,
        dictionaryDetailNpcMapUseCase: FetchDictionaryDetailNpcMapUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.dictionaryDetailNpcUseCase = dictionaryDetailNpcUseCase
        self.dictionaryDetailNpcQuestUseCase = dictionaryDetailNpcQuestUseCase
        self.dictionaryDetailNpcMapUseCase = dictionaryDetailNpcMapUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.initialState = State(
            npcDetailInfo: DictionaryDetailNpcResponse(
                npcId: 0, nameKr: "", nameEn: "", iconUrlDetail: nil, bookmarkId: nil
            ),
            maps: [],
            quests: [],
            id: id
        )
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return .just(.navigatTo(.filter(currentState.questFilter)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailNpcUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailNpcMapUseCase.execute(id: currentState.id).map { .setDetailMaps($0) },
                dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: nil).map { .setDetailQuests($0) }
            ])
        case let .selectFilter(type):
            return dictionaryDetailNpcQuestUseCase.execute(id: currentState.id, sort: type.sortParameter).map { .setDetailQuests($0) }

        case .toggleBookmark:
           return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case .mapTapped(index: let index):
            return .just(.navigatTo(.detail(type: .map, id: currentState.maps[index].mapId)))

        case .questTapped(index: let index):
            return .just(.navigatTo(.detail(type: .quest, id: currentState.quests[index].questId)))
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigatTo(let route):
            newState.route = route
        case let .setDetailData(data):
            newState.npcDetailInfo = data
        case let .setDetailMaps(data):
            newState.maps = data
        case let .setDetailQuests(data):
            newState.quests = data
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setLastDeletedBookmark(map):
            newState.lastDeletedBookmark = map
        case let .setEvent(event):
            newState.event = event
        }
        return newState
    }
}

private extension NpcDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var npc = currentState.npcDetailInfo
        let isSelected = npc.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: isSelected ? npc.bookmarkId ?? npc.npcId : npc.npcId,
            isBookmark: isSelected ? .delete : .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            npc.bookmarkId = newBookmarkId
            let event: UIEvent = isSelected ? .delete(npc) : .add(npc)
            let eventMutation = Observable.just(Mutation.setEvent(event))

            let refresh = self.dictionaryDetailNpcUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var npc = currentState.npcDetailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: npc.npcId,
            isBookmark: .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            npc.bookmarkId = newBookmarkId
            let eventMutation = Observable.just(Mutation.setEvent(.add(npc)))
            let refresh = self.dictionaryDetailNpcUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
