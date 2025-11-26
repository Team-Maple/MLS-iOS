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
        case dismissAddCollection([CollectionResponse])
        case itemTapped(Int)
    }

    public enum Mutation {
        case navigateTo(Route)
        case checkBookMarks([BookmarkResponse])
        case checkCollections([CollectionResponse])
    }

    public struct State {
        @Pulse var route: Route
        var bookmarks: [BookmarkResponse]
        var selectedItems = [BookmarkResponse]()
        var selectedCollections = [CollectionResponse]()
    }

    // MARK: - Properties
    public var initialState: State

    private let disposeBag = DisposeBag()

    public init(bookmarks: [BookmarkResponse]) {
        self.initialState = State(route: .none, bookmarks: bookmarks)
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
            let item = currentState.bookmarks[index]
            var newItems = currentState.selectedItems
            if let index = newItems.firstIndex(where: { $0.originalId == item.originalId }) {
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
