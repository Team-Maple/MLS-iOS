import DomainInterface
import Foundation
import ReactorKit

struct PopularItem {
    let rank: Int
    let name: String
}

public final class DictionarySearchReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case search(String)
    }

    public enum Action {
        case viewWillAppear
        case backButtonTapped
        case searchButtonTapped(String)
        case cancelRecentButtonTapped(String)
        case recentButtonTapped(String)
    }

    public enum Mutation {
        case navigateTo(Route)
        case deleteItem(String)
        case addRecentItem(String)
        case setRecentList([String])
    }

    public struct State {
        @Pulse var route: Route
        var recentResult: [String]
        let popularResult: [PopularItem]
    }

    public let recentSearchAddUseCase: RecentSearchAddUseCase
    public let recentSearchRemoveUseCase: RecentSearchRemoveUseCase
    public let recentSearchFetchUseCase: RecentSearchFetchUseCase

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(recentSearchAddUseCase: RecentSearchAddUseCase, recentSearchRemoveUseCase: RecentSearchRemoveUseCase, recentSearchFetchUseCase: RecentSearchFetchUseCase) {
        // TODO: 인기 검색어 추후 개발
        let items = [
            PopularItem(rank: 1, name: "주니어 예티"),
            PopularItem(rank: 2, name: "주니어 페페"),
            PopularItem(rank: 3, name: "주니어 네키"),
            PopularItem(rank: 4, name: "주니어 버섯"),
            PopularItem(rank: 5, name: "주니어 달팽이"),
            PopularItem(rank: 6, name: "주니어 유림"),
            PopularItem(rank: 7, name: "주니어 채령"),
            PopularItem(rank: 8, name: "주니어 진훈"),
            PopularItem(rank: 9, name: "주니어 여송"),
            PopularItem(rank: 10, name: "주니어 명범"),
            PopularItem(rank: 11, name: "주니어 재혁")
        ]
        let numberOfRows = Int(ceil(Double(items.count) / Double(2)))
        var grid = [[PopularItem?]](repeating: [PopularItem?](repeating: nil, count: 2), count: numberOfRows)

        for (index, item) in items.enumerated() {
            let row = index % numberOfRows
            let column = index / numberOfRows
            grid[row][column] = item
        }

        let newItems = grid.flatMap { $0.compactMap { $0 } }

        self.recentSearchAddUseCase = recentSearchAddUseCase
        self.recentSearchRemoveUseCase = recentSearchRemoveUseCase
        self.recentSearchFetchUseCase = recentSearchFetchUseCase

        let savedRecentResult: [String] = []

        self.initialState = State(
            route: .none,
            recentResult: savedRecentResult,
            popularResult: newItems
        )
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return recentSearchFetchUseCase.fetch().map { Mutation.setRecentList($0) }
        case .backButtonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .searchButtonTapped(let keyword):
            return recentSearchAddUseCase.add(keyword: keyword)
                .andThen(
                    currentState.recentResult.contains(keyword)
                        ? .just(.navigateTo(.search(keyword)))
                        : .concat([
                            .just(.addRecentItem(keyword)),
                            .just(.navigateTo(.search(keyword)))
                          ])
                )
        case .cancelRecentButtonTapped(let keyword):
            return recentSearchRemoveUseCase.remove(keyword: keyword)
                .andThen(.just(.deleteItem(keyword)))
        case .recentButtonTapped(let keyword):
            return Observable.just(.navigateTo(.search(keyword)))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setRecentList(let list):
            newState.recentResult = list
        case .navigateTo(let route):
            newState.route = route
        case .addRecentItem(let name):
            newState.recentResult.insert(name, at: 0) // 맨 앞에 최근 검색어 추가
        case .deleteItem(let name):
            newState.recentResult = state.recentResult.filter { $0 != name }
        }

        return newState
    }
}
