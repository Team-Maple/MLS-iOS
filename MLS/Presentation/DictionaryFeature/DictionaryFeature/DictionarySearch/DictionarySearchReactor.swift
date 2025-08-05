import Foundation
import ReactorKit

public final class DictionarySearchReactor: Reactor {
    struct PopularItem {
        let rank: Int
        let name: String
    }
    
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case search
    }

    public enum Action {
        case backButtonTapped
        case searchButtonTapped
    }

    public enum Mutation {
        case navigateTo(Route)
    }

    public struct State {
        @Pulse var route: Route
        let recentResult: [String]
        var hasRecent: Bool {
            !recentResult.isEmpty
        }

        let popularResult: [PopularItem]
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init() {
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
            PopularItem(rank: 11, name: "주니어 재혁"),
        ]
        let numberOfRows = Int(ceil(Double(items.count) / Double(2)))
        var grid = [[PopularItem?]](repeating: [PopularItem?](repeating: nil, count: 2), count: numberOfRows)

        for (index, item) in items.enumerated() {
            let row = index % numberOfRows
            let column = index / numberOfRows
            grid[row][column] = item
        }

        let newItems = grid.flatMap { $0.compactMap { $0 } }
        print(newItems)
        
        self.initialState = State(
            route: .none,
            recentResult: ["망치", "도끼", "창", "드라이버", "몽키스패너"],
            popularResult: newItems
        )
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.navigateTo(.dismiss))
        case .searchButtonTapped:
            return Observable.just(.navigateTo(.search))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        }

        return newState
    }
}
