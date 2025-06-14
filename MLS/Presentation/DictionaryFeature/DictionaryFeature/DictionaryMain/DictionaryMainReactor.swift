import ReactorKit

import DomainInterface

public final class DictionaryMainReactor: Reactor {
    // MARK: - Reactor
    public enum Action {}
        
    public enum Mutation {}
        
    public struct State {
        var sections = DictionaryType.allCases.map { $0.title }
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
