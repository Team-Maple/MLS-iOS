import DomainInterface

import ReactorKit

// MARK: - Reactor
public final class ItemDictionaryDetailReactor: Reactor {
    // MARK: Type
    public enum Route {
        case none
        case filter(DictionaryType)
        case detail(Int)
        case bookmarkError
    }

    public enum UIEvent {
        case none
        case add(DictionaryDetailItemResponse)
        case delete(DictionaryDetailItemResponse)
        case undo
    }

    // MARK: Action
    public enum Action {
        case filterButtonTapped
        case viewWillAppear
        case selectFilter(SortType)
        case toggleBookmark
        case undoLastDeletedBookmark
        case dataTapped(index: Int)
    }

    // MARK: Mutation
    public enum Mutation {
        case navigatTo(Route)
        case setDetailData(DictionaryDetailItemResponse)
        case setDetailDropMonsterData([DictionaryDetailItemDropMonsterResponse])
        case setLoginState(Bool)
        case setEvent(UIEvent)
    }

    // MARK: State
    public struct State {
        @Pulse var event: UIEvent = .none
        @Pulse var route: Route = .none
        var itemDetailInfo: DictionaryDetailItemResponse
        var type: DictionaryType = .item
        var monsters: [DictionaryDetailItemDropMonsterResponse]
        var id: Int
        var isLogin = false
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    private let dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase
    private let dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase
    private let checkLoginUseCase: CheckLoginUseCase
    private let setBookmarkUseCase: SetBookmarkUseCase

    // MARK: Init
    public init(
        dictionaryDetailItemUseCase: FetchDictionaryDetailItemUseCase,
        dictionaryDetailItemDropMonsterUseCase: FetchDictionaryDetailItemDropMonsterUseCase,
        checkLoginUseCase: CheckLoginUseCase,
        setBookmarkUseCase: SetBookmarkUseCase,
        id: Int
    ) {
        self.dictionaryDetailItemUseCase = dictionaryDetailItemUseCase
        self.dictionaryDetailItemDropMonsterUseCase = dictionaryDetailItemDropMonsterUseCase
        self.checkLoginUseCase = checkLoginUseCase
        self.setBookmarkUseCase = setBookmarkUseCase
        self.initialState = .init(
            itemDetailInfo: DictionaryDetailItemResponse(
                itemId: 0, nameKr: nil, nameEn: nil, descriptionText: nil,
                imgUrl: nil, npcPrice: nil, itemType: nil, categoryHierachy: nil,
                availableJobs: nil, requiredStats: nil, equipmentStats: nil,
                scrollDetail: nil, bookmarkId: nil
            ),
            type: .item,
            monsters: [],
            id: id
        )
    }

    // MARK: Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .filterButtonTapped:
            return .just(.navigatTo(.filter(currentState.type)))
        case .viewWillAppear:
            return .merge([
                checkLoginUseCase.execute().map { .setLoginState($0) },
                dictionaryDetailItemUseCase.execute(id: currentState.id).map { .setDetailData($0) },
                dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: nil).map { .setDetailDropMonsterData($0) }
            ])
        case let .selectFilter(type):
            return dictionaryDetailItemDropMonsterUseCase.execute(id: currentState.id, sort: type.sortParameter).map { .setDetailDropMonsterData($0) }

        case .toggleBookmark:
           return handleToggleBookmark()

        case .undoLastDeletedBookmark:
            return handleUndoLastDeletedBookmark()

        case .dataTapped(let index):
            guard let id = currentState.monsters[index].monsterId else { return .empty() }
            return .just(.navigatTo(.detail(id)))
        }
    }

    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setDetailData(data):
            newState.itemDetailInfo = data
        case let .setDetailDropMonsterData(data):
            newState.monsters = data
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        case .navigatTo(let route):
            newState.route = route
        case let .setEvent(event):
            newState.event = event
        }
        return newState
    }
}

private extension ItemDictionaryDetailReactor {
    func handleToggleBookmark() -> Observable<Mutation> {
        var item = currentState.itemDetailInfo
        let isSelected = item.bookmarkId != nil
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: isSelected ? item.bookmarkId ?? item.itemId : item.itemId,
            isBookmark: isSelected ? .delete : .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            item.bookmarkId = newBookmarkId
            let event: UIEvent = isSelected ? .delete(item) : .add(item)
            let eventMutation = Observable.just(Mutation.setEvent(event))

            let refresh = self.dictionaryDetailItemUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }

    func handleUndoLastDeletedBookmark() -> Observable<Mutation> {
        var item = currentState.itemDetailInfo
        guard let type = currentState.type.toItemType else { return .empty() }

        return setBookmarkUseCase.execute(
            bookmarkId: item.itemId,
            isBookmark: .set(type)
        )
        .flatMap { [weak self] newBookmarkId -> Observable<Mutation> in
            guard let self else { return .empty() }

            item.bookmarkId = newBookmarkId
            let eventMutation = Observable.just(Mutation.setEvent(.add(item)))
            let refresh = self.dictionaryDetailItemUseCase.execute(id: self.currentState.id)
                .map { Mutation.setDetailData($0) }

            return .concat([eventMutation, refresh])
        }
        .catch { _ in
            .just(.navigatTo(.bookmarkError))
        }
    }
}
