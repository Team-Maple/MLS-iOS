import ReactorKit

import DomainInterface

public final class DictionarySearchReactor: Reactor {
    // MARK: - Reactor
    public enum Action {}
        
    public enum Mutation {}
        
    public struct State {
        let recentResult: [String]
        var hasRecent: Bool {
            !recentResult.isEmpty
        }

        let popularResult: [String]
    }
        
    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()
        
    // MARK: - init
    public init() {
        self.initialState = State(
            recentResult: ["망치", "도끼", "창", "드라이버", "몽키스패너"],
//            recentResult: [],
            popularResult: [
                "주니어 예티",
                "주니어 페페",
                "주니어 네키",
                "주니어 버섯",
                "주니어 달팽이",
                "주니어 유림",
                "주니어 채령",
                "주니어 진훈",
                "주니어 준영",
                "주니어 명범",
                "주니어 진혁"
            ]
        )
    }
        
    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {}
    }
        
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {}
            
        return newState
    }
}
