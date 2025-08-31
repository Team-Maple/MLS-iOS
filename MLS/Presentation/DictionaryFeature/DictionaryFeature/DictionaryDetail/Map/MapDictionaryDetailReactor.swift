import DomainInterface

import ReactorKit

public final class MapDictionaryDetailReactor: Reactor {
    public enum Action {

    }

    public enum Mutation {

    }

    public struct State {
        var type: DictionaryItemType
        var name = "슈미의 의뢰"
        lazy var sectionTab: [DetailType] = self.type.detailTypes
        var subTextLabel = "LV.21"
    }

    public var initialState: State
    private let disposBag = DisposeBag()

    public init() {
        initialState = State(type: .monster)
    }

    public func mutate(action: Action) -> Observable<Mutation> {

    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
