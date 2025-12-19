import DomainInterface

import ReactorKit

public final class MonsterDictionaryDetailReactor: Reactor {
    // MARK: - Type
    public enum Route {
        case none
        case filter(type: DictionaryType, sort: [SortType])
        case detail(type: DictionaryType, id: Int)
        case bookmarkError
    }

    public struct Info: Equatable {
        var name: String
        var desc: String
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailMonsterResponse)
        case delete(DictionaryDetailMonsterResponse)
        case undo
    }

    // MARK: - Action
    public enum Action {
        case filterButtonTapped(DictionaryType)
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark
        case undoLastDeletedBookmark
        case itemTapped(index: Int)
        case mapTapped(index: Int)
    }

    // MARK: - Mutation
    public enum Mutation {
        case navigatTo(Route)
        case setDetailData(DictionaryDetailMonsterResponse)
        case setDetailDropItemData([DictionaryDetailMonsterDropItemResponse])
        case setDetailMapData([DictionaryDetailMonsterMapResponse])
        case setBookmark(DictionaryDetailMonsterResponse)
        case setLastDeletedBookmark(DictionaryDetailMonsterResponse?)
        case setLoginState(Bool)
        case setEvent(UIEvent)
    }

    // MARK: - State
    public struct State {
        @Pulse var event: UIEvent = .none
        @Pulse var route: Route = .none
        var type: DictionaryType = .monster
        var id = 0
        var monsterDetailInfo = DictionaryDetailMonsterResponse(
            monsterId: 0, nameKr: "", nameEn: "", imageUrl: "",
            level: 0, exp: 0, hp: 0, mp: 0,
            physicalDefense: 0, magicDefense: 0,
            requiredAccuracy: 0, bonusAccuracyPerLevelLower: 0,
            evasionRate: 0, mesoDropAmount: nil, mesoDropRate: nil,
            typeEffectiveness: nil, bookmarkId: nil
        )
        var spawnMaps = [DictionaryDetailMonsterMapResponse]()
        var dropItems = [DictionaryDetailMonsterDropItemResponse]()
        var mapFilter: [SortType] {
            type.detailTypes[0].sortFilter
        }

        var itemFilter: [SortType] {
            type.detailTypes[1].sortFilter
        }
        var infos = [Info]()
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailMonsterResponse?
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase
    private let dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase
    private let dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    public var initialState: State

    // MARK: - Init
    public init(
        dictionaryDetailMonsterUseCase: FetchDictionaryDetailMonsterUseCase,
        dictionaryDetailMonsterDropItemUseCase: FetchDictionaryDetailMonsterItemsUseCase,
        dictionaryDetailMonsterMapUseCase: FetchDictionaryDetailMonsterMapUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.initialState = State(type: .monster, id: id)
        self.dictionaryDetailMonsterUseCase = dictionaryDetailMonsterUseCase
        self.dictionaryDetailMonsterDropItemUseCase = dictionaryDetailMonsterDropItemUseCase
        self.dictionaryDetailMonsterMapUseCase = dictionaryDetailMonsterMapUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .filterButtonTapped(type):
            return .just(.navigatTo(.filter(type: type, sort: type == .map ? currentState.mapFilter : currentState.itemFilter)))

        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailMonsterUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: nil).map { .setDetailDropItemData($0) },
                dictionaryDetailMonsterMapUseCase.execute(id: currentState.id).map { .setDetailMapData($0) }
            ])

        case let .selectFilter(type):
            return dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: type.sortParameter).map { .setDetailDropItemData($0) }

        case .toggleBookmark:
           return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case .itemTapped(index: let index):
            return .just(.navigatTo(.detail(type: .item, id: currentState.dropItems[index].itemId)))

        case .mapTapped(index: let index):
            return .just(.navigatTo(.detail(type: .map, id: currentState.spawnMaps[index].mapId)))
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .navigatTo(route):
            newState.route = route

        case let .setDetailData(data):
            newState.monsterDetailInfo = data

            var infos: [Info] = []
            infos.append(.init(name: "HP", desc: "\(data.hp.formatted())"))
            infos.append(.init(name: "MP", desc: "\(data.mp.formatted())"))
            infos.append(.init(name: "EXP", desc: "\(data.exp.formatted())"))
            infos.append(.init(name: "물리방어력", desc: "\(data.physicalDefense.formatted())"))
            infos.append(.init(name: "마법방어력", desc: "\(data.magicDefense.formatted())"))
            newState.infos = infos

        case let .setDetailDropItemData(data):
            newState.dropItems = data

        case let .setDetailMapData(data):
            newState.spawnMaps = data

        case let .setBookmark(monster):
            newState.monsterDetailInfo = monster

        case let .setLastDeletedBookmark(monster):
            newState.lastDeletedBookmark = monster

        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setEvent(event):
            newState.event = event
        }

        return newState
    }
}

private extension MonsterDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var monster = currentState.monsterDetailInfo
        let isSelected = monster.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: isSelected ? monster.bookmarkId ?? monster.monsterId : monster.monsterId,
            isBookmark: isSelected ? .delete : .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            monster.bookmarkId = newBookmarkId
            let event: UIEvent = isSelected ? .delete(monster) : .add(monster)
            let eventMutation = Observable.just(Mutation.setEvent(event))

            let refresh = self.dictionaryDetailMonsterUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var monster = currentState.monsterDetailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: monster.monsterId,
            isBookmark: .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            monster.bookmarkId = newBookmarkId
            let eventMutation = Observable.just(Mutation.setEvent(.add(monster)))
            let refresh = self.dictionaryDetailMonsterUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
