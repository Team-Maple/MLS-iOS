import DomainInterface

import ReactorKit

public final class BookmarkListReactor: Reactor {
    public enum Route {
        case none
        case sort(DictionaryType)
        case filter(DictionaryType)
    }

    public enum Action {
        case toggleBookmark(String)
        case viewWillAppear
        case sortButtonTapped
        case filterbButtonTapped
    }

    public enum Mutation {
        case setItems([DictionaryItem])
        case showSortFilter
        case showFilter
        case setLoginState(Bool)
    }

    public struct State {
        @Pulse var route: Route
        var items: [DictionaryItem] = []
        var type: DictionaryType
        var isLogin: Bool
    }

    public var initialState: State

    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    private let checkLoginUseCase: CheckLoginUseCase

    private let disposeBag = DisposeBag()

    public init(
        type: DictionaryType,
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase,
        checkLoginUseCase: CheckLoginUseCase
    ) {
        self.initialState = State(route: .none, type: type, isLogin: false)
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.checkLoginUseCase = checkLoginUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return checkLoginUseCase.execute()
                .flatMap { [weak self] isLoggedIn -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    if !isLoggedIn {
                        return .just(.setLoginState(false))
                    }

                    return Observable.concat([
                        .just(.setLoginState(true)),
                        fetchDictionaryItemsUseCase.execute(type: self.currentState.type)
                            .map { Mutation.setItems($0) }
                    ])
                }
        case let .toggleBookmark(id):
            return toggleBookmarkUseCase.execute(id: id, type: currentState.type)
                .map { Mutation.setItems($0) }
        case .sortButtonTapped:
            return Observable.just(.showSortFilter)
        case .filterbButtonTapped:
            return Observable.just(.showFilter)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setItems(items):
            newState.items = items
        case .showSortFilter:
            newState.route = .sort(newState.type)
        case .showFilter:
            newState.route = .filter(newState.type)
        case let .setLoginState(isLogin):
            newState.isLogin = isLogin
        }
        return newState
    }
}
