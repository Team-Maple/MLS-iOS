import UIKit

import BookmarkFeatureInterface
import DomainInterface

import ReactorKit

public final class CollectionListReactor: Reactor {
    public enum Route {
        case none
        case detail(BookmarkCollection)
    }

    public enum Action {
        case itemTapped(Int)
        case viewWillAppear
        case addCollection(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case setListData([CollectionListResponse])
    }

    public struct State {
        @Pulse var route: Route
        var collections: [BookmarkCollection]
        var collectionListData: [CollectionListResponse]
    }

    // MARK: - Properties
    public var initialState: State

    private let disposeBag = DisposeBag()
    
    private let collectionListUseCase: FetchCollectionListUseCase
    private let createCollectionListUseCase: CreateCollectionListUseCase

    public init(
        collectionListUseCase: FetchCollectionListUseCase,
        createCollectionListUseCase: CreateCollectionListUseCase
    ) {
        self.collectionListUseCase = collectionListUseCase
        self.createCollectionListUseCase = createCollectionListUseCase
        self.initialState = State(route: .none, collections: [
            BookmarkCollection(id: 1, title: "1000번", items: [
                DictionaryItem(id: 1, type: .item, mainText: "1번 아이템", subText: "1번 설명", image: .add, isBookmarked: false),
                DictionaryItem(id: 2, type: .item, mainText: "2번 아이템", subText: "2번 설명", image: .add, isBookmarked: false)
            ]),
            BookmarkCollection(id: 2, title: "2000번", items: [
                DictionaryItem(id: 3, type: .item, mainText: "3번 아이템", subText: "3번 설명", image: .add, isBookmarked: false),
                DictionaryItem(id: 4, type: .item, mainText: "4번 아이템", subText: "4번 설명", image: .add, isBookmarked: false)
            ])
        ], collectionListData: [])
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return collectionListUseCase.execute().map { .setListData($0) }
        case .itemTapped(let index):
            return .just(.navigateTo(.detail(currentState.collections[index])))
        case .addCollection(let collection):
            return createCollectionListUseCase.execute(name: collection).andThen(collectionListUseCase.execute())
                .map {.setListData($0)}
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setListData(let data):
            newState.collectionListData = data
        case .navigateTo(let route):
            newState.route = route
        }
        return newState
    }
}
