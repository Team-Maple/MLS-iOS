import ReactorKit

public final class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Action {}
        
    public enum Mutation {}
        
    public struct State {
        var sections: [String] = [
            "전체",
            "몬스터",
            "아이템",
            "맵",
            "NPC",
            "퀘스트",
        ]
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
        switch action {}
    }
        
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
            
        switch mutation {}
            
        return newState
    }
}
