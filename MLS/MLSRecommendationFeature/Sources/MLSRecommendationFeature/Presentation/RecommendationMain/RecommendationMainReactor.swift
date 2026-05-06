import ReactorKit
import RxCocoa
import RxSwift

final class RecommendationMainReactor: Reactor {

    // MARK: - Reactor
    enum Action {
        case informationButtonTapped
    }

    enum Mutation {
        case informationButtonToggle
    }

    struct State {
        var informationButtonIsOn: Bool = false
    }

    // MARK: - properties
    var initialState: State
    var disposeBag = DisposeBag()

    // MARK: - init
    init() {
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .informationButtonTapped:
            return .just(.informationButtonToggle)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .informationButtonToggle:
            newState.informationButtonIsOn.toggle()
        }
        return newState
    }
}
