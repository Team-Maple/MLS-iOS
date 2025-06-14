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
        case showToast(String)
    }

    public struct State {
        var items: [DictionaryItem] = []
        var toastMessage: String? = nil
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
                        .map { newItems -> [Mutation] in
                            var mutations: [Mutation] = [.setItems(newItems)]
                            
                            if let newItem = newItems.first(where: { $0.id == id }), newItem.isBookmarked {
                                mutations.append(.showToast("북마크에 추가됐어요!"))
                            }
                            
                            return mutations
                        }
                        .flatMap { Observable.from($0) }
                }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setItems(items):
            newState.items = items
            newState.toastMessage = nil
        case let .showToast(message):
            newState.toastMessage = message
        }

        return newState
    }
}
