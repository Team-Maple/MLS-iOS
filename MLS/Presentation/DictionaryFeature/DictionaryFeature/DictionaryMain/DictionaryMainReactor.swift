import ReactorKit

public class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Action {}
        
    public enum Mutation {}
        
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
