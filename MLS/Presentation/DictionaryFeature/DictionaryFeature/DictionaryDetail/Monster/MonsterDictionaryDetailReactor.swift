import DomainInterface

import ReactorKit

public final class MonsterDictionaryDetailReactor: Reactor {
    // MARK: - Type
    public enum Route {
        case none
        case filter(DictionaryType)
    }

    public struct Info: Equatable {
        var name: String
        var desc: String
    }

    // MARK: - Action
    public enum Action {
        case filterButtonTapped(DictionaryType)
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark(Bool)
        case undoLastDeletedBookmark
    }

    // MARK: - Mutation
    public enum Mutation {
        case showFilter(DictionaryType)
        case setDetailData(DictionaryDetailMonsterResponse)
        case setDetailDropItemData([DictionaryDetailMonsterDropItemResponse])
        case setDetailMapData([DictionaryDetailMonsterMapResponse])
        case setBookmark(DictionaryDetailMonsterResponse)
        case setLastDeletedBookmark(DictionaryDetailMonsterResponse?)
        case setLoginState(Bool)
    }

    // MARK: - State
    public struct State {
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
        var dropItems = [DictionaryDetailMonsterDropItemResponse]()
        var spawnMaps = [DictionaryDetailMonsterMapResponse]()
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
            return .just(.showFilter(type))

        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailMonsterUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: nil).map { .setDetailDropItemData($0) },
                dictionaryDetailMonsterMapUseCase.execute(id: currentState.id).map { .setDetailMapData($0) }
            ])

        case let .selectFilter(type):
            switch type {
            case .levelDESC: // 레벨 높은 순
                return dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: ["level", "desc"]).map { .setDetailDropItemData($0) }
            case .levelASC: // 레벨 낮은 순
                return dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: ["level", "asc"]).map { .setDetailDropItemData($0) }
            case .mostDrop:
                return dictionaryDetailMonsterDropItemUseCase.execute(id: currentState.id, sort: nil).map { .setDetailDropItemData($0) }
            default:
                return .empty()
            }

        case let .toggleBookmark(isSelected):
            let monsterId = currentState.monsterDetailInfo.monsterId

            let saveDeleted: Observable<Mutation> = isSelected
                ? .just(.setLastDeletedBookmark(currentState.monsterDetailInfo))
                : .just(.setLastDeletedBookmark(nil))

            return saveDeleted.concat(
                setBookmarkUseCase.execute(
                    bookmarkId: currentState.monsterDetailInfo.bookmarkId ?? monsterId,
                    isBookmark: isSelected ? .delete : .set(.monster)
                )
                .andThen(dictionaryDetailMonsterUseCase.execute(id: currentState.id).map { .setDetailData($0) })
            )

        case .undoLastDeletedBookmark:
            guard let lastDeleted = currentState.lastDeletedBookmark else { return .empty() }
            let monsterId = lastDeleted.monsterId

            return setBookmarkUseCase.execute(
                bookmarkId: monsterId,
                isBookmark: .set(.monster)
            )
            .andThen(
                Observable.concat([
                    dictionaryDetailMonsterUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                    .just(.setLastDeletedBookmark(nil))
                ])
            )
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .showFilter(type):
            newState.route = .filter(type)

        case let .setDetailData(data):
            newState.monsterDetailInfo = data

            var infos: [Info] = []
            infos.append(.init(name: "HP", desc: "\(data.hp)"))
            infos.append(.init(name: "MP", desc: "\(data.mp)"))
            infos.append(.init(name: "EXP", desc: "\(data.exp)"))
            infos.append(.init(name: "물리방어력", desc: "\(data.physicalDefense)"))
            infos.append(.init(name: "마법방어력", desc: "\(data.magicDefense)"))
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
        }

        return newState
    }
}
