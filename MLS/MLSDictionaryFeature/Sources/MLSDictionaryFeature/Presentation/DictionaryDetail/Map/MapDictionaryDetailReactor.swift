import MLSBookmarkFeatureInterface
import MLSDictionaryFeatureInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case filter([SortType])
        case detail(type: DictionaryType, id: Int)
        case bookmarkError
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailMapResponse)
        case delete(DictionaryDetailMapResponse)
        case undo
    }

    public enum Action {
        case monsterFilterButtonTapped
        case viewWillAppear
        case toggleBookmark
        case undoLastDeletedBookmark
        case monsterTapped(index: Int)
        case npcTapped(index: Int)
        case selectFilter(SortType)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setDetailData(DictionaryDetailMapResponse)
        case setDetailSpawnMonsters([DictionaryDetailMapSpawnMonsterResponse])
        case setDetailNpc([DictionaryDetailMapNpcResponse])
        case setBookmark(DictionaryDetailMapResponse)
        case setLastDeletedBookmark(DictionaryDetailMapResponse?)
        case setLoginState(Bool)
        case setEvent(UIEvent)
    }

    public let dictionaryDetailAPIRepository: DictionaryDetailAPIRepository
    private let bookmarkRepository: BookmarkRepository
    private let checkLoginUseCase: CheckLoginUseCase

    public struct State {
        @Pulse var event: UIEvent = .none
        @Pulse var route: Route = .none
        var mapDetailInfo: DictionaryDetailMapResponse
        var spawnMonsters: [DictionaryDetailMapSpawnMonsterResponse]
        var npcs: [DictionaryDetailMapNpcResponse]
        var type: DictionaryType = .map
        var monsterFilter: [SortType] {
            type.detailTypes[0].sortFilter
        }
        var id = 0
        var isLogin = false
        var lastDeletedBookmark: DictionaryDetailMapResponse?
    }

    public var initialState: State
    private let disposBag = DisposeBag()

    public init(
        dictionaryDetailAPIRepository: DictionaryDetailAPIRepository,
        bookmarkRepository: BookmarkRepository,
        checkLoginUseCase: CheckLoginUseCase,
        id: Int
    ) {
        initialState = State(
            mapDetailInfo: DictionaryDetailMapResponse(
                mapId: 0,
                nameKr: nil,
                nameEn: nil,
                regionName: nil,
                detailName: nil,
                topRegionName: nil,
                mapUrl: nil,
                iconUrl: nil,
                bookmarkId: nil
            ),
            spawnMonsters: [],
            npcs: [],
            type: .map,
            id: id
        )

        self.dictionaryDetailAPIRepository = dictionaryDetailAPIRepository
        self.bookmarkRepository = bookmarkRepository
        self.checkLoginUseCase = checkLoginUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .monsterFilterButtonTapped:
            return Observable.just(.navigateTo(.filter(currentState.monsterFilter)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailAPIRepository.fetchMapDetail(id: currentState.id).map {.setDetailData($0)},
                dictionaryDetailAPIRepository.fetchMapDetailSpawnMonster(id: currentState.id, sort: nil).map {.setDetailSpawnMonsters($0)},
                dictionaryDetailAPIRepository.fetchMapDetailNpc(id: currentState.id).map {.setDetailNpc($0)}
            ])
        case .toggleBookmark:
           return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case let .selectFilter(type):
            return dictionaryDetailAPIRepository.fetchMapDetailSpawnMonster(id: currentState.id, sort: type.sortParameter).map { .setDetailSpawnMonsters($0) }

        case .monsterTapped(index: let index):
            guard let id = currentState.spawnMonsters[index].monsterId else { return .empty() }

            return .just(.navigateTo(.detail(type: .monster, id: id)))
        case .npcTapped(index: let index):
            guard let id = currentState.npcs[index].npcId else { return .empty() }
            return .just(.navigateTo(.detail(type: .npc, id: id)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case let .setDetailData(data):
            newState.mapDetailInfo = data
        case let .setDetailSpawnMonsters(data):
            newState.spawnMonsters = data
        case let .setDetailNpc(data):
            newState.npcs = data
        case let .setBookmark(map):
            newState.mapDetailInfo = map
        case let .setLastDeletedBookmark(map):
            newState.lastDeletedBookmark = map
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case let .setEvent(event):
            newState.event = event
        }
        return newState
    }
}

private extension MapDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var map = currentState.mapDetailInfo
        let isSelected = map.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        let bookmarkObservable: Observable<Int?>

        if isSelected, let bookmarkId = map.bookmarkId {
            bookmarkObservable = bookmarkRepository
                .deleteBookmark(bookmarkId: bookmarkId)
        } else {
            bookmarkObservable = bookmarkRepository
                .setBookmark(resourceId: map.mapId, type: type)
                .map { Optional($0) }
        }

        return bookmarkObservable
            .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
                guard let self else { return .empty() }

                map.bookmarkId = newBookmarkId
                let event: UIEvent = isSelected ? .delete(map) : .add(map)
                let eventMutation = Observable.just(Mutation.setEvent(event))

                let refresh = self.dictionaryDetailAPIRepository
                    .fetchMapDetail(id: self.currentState.id)
                    .map { Mutation.setDetailData($0) }

                return .concat([eventMutation, refresh])
            }
            .catch { _ in
                .just(.navigateTo(.bookmarkError))
            }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var map = currentState.mapDetailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return bookmarkRepository
            .setBookmark(resourceId: map.mapId, type: type)
            .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
                guard let self else { return .empty() }

                map.bookmarkId = newBookmarkId
                let eventMutation = Observable.just(Mutation.setEvent(.add(map)))
                let refresh = self.dictionaryDetailAPIRepository
                    .fetchMapDetail(id: self.currentState.id)
                    .map { Mutation.setDetailData($0) }

                return .concat([eventMutation, refresh])
            }
            .catch { _ in
                .just(.navigateTo(.bookmarkError))
            }
    }
}
