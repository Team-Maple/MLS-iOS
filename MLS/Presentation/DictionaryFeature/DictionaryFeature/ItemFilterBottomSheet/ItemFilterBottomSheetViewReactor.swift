import ReactorKit
import RxSwift
import RxCocoa

final public class ItemFilterBottomSheetViewReactor: Reactor {
    public enum Route {
        case none
        case dismiss
    }
    // MARK: - Reactor
    public enum Action {
        case closeButtonTapped
    }
    
    public enum Mutation {
        case navigateTo(route: Route)
    }
    
    public struct State {
        var sections: [String] = [
            "직업/레벨",
            "무기",
            "발사체",
            "방어구",
            "장신구",
            "주문서",
            "기타"
        ]
        var jobs: [String] = [
            "없음",
            "공용",
            "마법사",
            "전사",
            "궁수",
            "도적",
            "해적"
        ]
        var weapons: [String] = []
        var projectiles: [String] = []
        var armors: [String] = []
        var accessories: [String] = []
        var scrolls: [String] = []
        var etcItems: [String] = []
        
        @Pulse var route: Route = .none
    }
    
    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
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
