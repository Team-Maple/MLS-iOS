import DesignSystem
import DomainInterface

import ReactorKit

open class DictionaryListReactor: Reactor {
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
    }

    public struct State {
        @Pulse var route: Route
        public var items: [DictionaryItem] = []
        public var type: DictionaryType
    }

    public var initialState: State

    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let disposeBag = DisposeBag()

    public init(
        type: DictionaryType,
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        self.initialState = State(route: .none, type: type)
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchDictionaryItemsUseCase.execute(type: currentState.type)
                .map { Mutation.setItems($0) }

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
        }
        return newState
    }
}
