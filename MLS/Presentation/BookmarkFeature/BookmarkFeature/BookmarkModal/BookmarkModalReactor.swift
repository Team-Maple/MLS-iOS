import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class BookmarkModalReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case addCollection
    }

    public enum Action {
        case backButtonTapped
        case addCollectionTapped
        case selectItem(Int)
    }

    public enum Mutation {
        case toNavigate(Route)
        case checkCollection([BookmarkCollection])
    }

    public struct State {
        @Pulse var route: Route
        var collections = [
            BookmarkCollection(id: 1, title: "1번", items: [
                DictionaryItem(id: 1, type: .item, mainText: "메인", subText: "서브", image: .checkmark, isBookmarked: true),
                DictionaryItem(id: 2, type: .monster, mainText: "메인", subText: "서브", image: .checkmark, isBookmarked: false)
            ]),
            BookmarkCollection(id: 2, title: "3번", items: [
                DictionaryItem(id: 3, type: .item, mainText: "메인", subText: "서브", image: .checkmark, isBookmarked: true),
                DictionaryItem(id: 4, type: .monster, mainText: "메인", subText: "서브", image: .checkmark, isBookmarked: false)
            ])
        ]
        var selectedItems = [BookmarkCollection]()
    }

    public var initialState: State

    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State(route: .none)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))
        case .addCollectionTapped:
            return .just(.toNavigate(.addCollection))
        case .selectItem(let index):
            let item = currentState.collections[index - 1]
            var newItems = currentState.selectedItems
            if let index = newItems.firstIndex(where: { $0.id == item.id }) {
                newItems.remove(at: index)
            } else {
                newItems.append(item)
            }
            return .just(.checkCollection(newItems))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case .checkCollection(let collections):
            newState.selectedItems = collections
        }
        return newState
    }
}
