import UIKit

import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionEditReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case collcectionList
    }

    public enum Action {
        case backButtonTapped
        case addCollectionButtonTapped
        case completeButtonTapped
        case dismissAddCollection([BookmarkCollection])
        case itemTapped(Int)
    }

    public enum Mutation {
        case navigateTo(Route)
        case checkBookMarks([DictionaryItem])
        case checkCollections([BookmarkCollection])
    }

    public struct State {
        @Pulse var route: Route
        var collection: BookmarkCollection
        var selectedItems = [DictionaryItem]()
        var selectedCollections = [BookmarkCollection]()
    }

    // MARK: - Properties
    public var initialState: State

    private let disposeBag = DisposeBag()

    public init() {
        self.initialState = State(route: .none, collection:
            BookmarkCollection(id: 3, title: "2번", items: [
                DictionaryItem(id: 3, type: .item, mainText: "3번 아이템", subText: "3번 설명", image: .add, isBookmarked: false),
                DictionaryItem(id: 4, type: .item, mainText: "4번 아이템", subText: "4번 설명", image: .add, isBookmarked: false)
            ]))
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return .just(.navigateTo(.dismiss))
        case .addCollectionButtonTapped:
            // 체크한 북마크를 selectedCollections에 추가하고 route를 .collectionList로
            return .just(.navigateTo(.collcectionList))
        case .completeButtonTapped:
            // 선택된 북마크들을 선택된 컬렉션들에 저장
            return .empty()
        case .dismissAddCollection(let collections):
            // addCollection에서 선택된 컬렉션 목록 저장
            return .empty()
        case .itemTapped(let index):
            let item = currentState.collection.items[index]
            var newItems = currentState.selectedItems
            if let index = newItems.firstIndex(where: { $0.id == item.id }) {
                newItems.remove(at: index)
            } else {
                newItems.append(item)
            }
            return .just(.checkBookMarks(newItems))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .checkBookMarks(let bookmarks):
            newState.selectedItems = bookmarks
        case .checkCollections(let collections):
            newState.selectedCollections = collections
        }
        return newState
    }
}
