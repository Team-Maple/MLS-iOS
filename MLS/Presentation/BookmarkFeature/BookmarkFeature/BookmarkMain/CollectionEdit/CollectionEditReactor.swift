import UIKit

import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import ReactorKit

public final class CollectionEditReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case detail(BookmarkCollection)
    }

    public enum Action {
        case backButtonTapped
        case toggleBookmark(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setItems([DictionaryItem])
    }

    public struct State {
        @Pulse var route: Route
        var collection: BookmarkCollection
    }

    // MARK: - Properties
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase
    
    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(toggleBookmarkUseCase: ToggleBookmarkUseCase) {
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
        self.initialState = State(route: .none, collection:
            BookmarkCollection(title: "2번", items: [
                DictionaryItem(id: "3", type: .item, mainText: "3번 아이템", subText: "3번 설명", image: .add, isBookmarked: false),
                DictionaryItem(id: "4", type: .item, mainText: "4번 아이템", subText: "4번 설명", image: .add, isBookmarked: false),
            ]))
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .toggleBookmark(let id):
            return toggleBookmarkUseCase.execute(id: id, type: .total)
                .map { Mutation.setItems($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setItems(let items):
            newState.collection.items = items
        }
        return newState
    }
}
