import DesignSystem
import DomainInterface

import ReactorKit

public final class DictionaryListReactor: Reactor {
    public enum Action {
        case load
        case toggleBookmark(String)
    }

    public enum Mutation {
        case setItems([DictionaryItem])
    }

    public struct State {
        var items: [DictionaryItem] = []
    }

    public var initialState = State()

    // MARK: - Dependencies
    private let fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    private let dictionaryType: DictionaryType

    public init(
        type: DictionaryType,
        fetchDictionaryItemsUseCase: FetchDictionaryItemsUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        self.dictionaryType = type
        self.fetchDictionaryItemsUseCase = fetchDictionaryItemsUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return fetchDictionaryItemsUseCase.execute(type: dictionaryType)
                .map(Mutation.setItems)

        case let .toggleBookmark(id):
            return toggleBookmarkUseCase.execute(id: id)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    guard let self = self else { return .empty() }
                    return self.fetchDictionaryItemsUseCase.execute(type: self.dictionaryType)
                        .map(Mutation.setItems)
                }
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
