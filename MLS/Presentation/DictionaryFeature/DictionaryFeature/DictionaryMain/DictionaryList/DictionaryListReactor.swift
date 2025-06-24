import DesignSystem
import DomainInterface

import ReactorKit

public final class DictionaryListReactor: Reactor {
    public enum Action {
        case toggleBookmark(String)
        case viewWillAppear
    }

    public enum Mutation {
        case setItems([DictionaryItem])
    }

    public struct State {
        var items: [DictionaryItem] = []
    }

    public var initialState: State

    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let dictionaryType: DictionaryType
    private let disposeBag = DisposeBag()

    public init(
        type: DictionaryType,
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        self.initialState = State()
        self.dictionaryType = type
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchDictionaryItemsUseCase.execute(type: dictionaryType)
                .map { Mutation.setItems($0) }

        case let .toggleBookmark(id):
            return toggleBookmarkUseCase.execute(id: id, type: dictionaryType)
                .map { Mutation.setItems($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setItems(items):
            newState.items = items
        }
        return newState
    }
}
