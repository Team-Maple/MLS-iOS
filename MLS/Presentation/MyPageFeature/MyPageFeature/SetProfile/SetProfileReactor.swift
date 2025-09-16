import DomainInterface

import ReactorKit

public final class SetProfileReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case imageBottomSheet
    }

    // MARK: - Action
    public enum Action {
        case showBottomSheet
        case inputNickName(String)
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
        case setNickName(String)
        case showError(Bool)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        var setProfileState: SetProfileView.SetProfileState
        var nickName: String = ""
        var isShowError = false
    }

    // MARK: - Properties
    public var initialState = State(setProfileState: .normal)
    
    private let checkNickNameUseCase: CheckNickNameUseCase

    // MARK: - Init
    public init(checkNickNameUseCase: CheckNickNameUseCase) {
        self.checkNickNameUseCase = checkNickNameUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showBottomSheet:
            return .just(.toNavigate(.imageBottomSheet))
        case .inputNickName(let nickName):
            return checkNickNameUseCase.excute(nickName: nickName)
                .map { isValid in
                    [.setNickName(nickName), .showError(isValid)]
                }
                .flatMap { Observable.from($0) }
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case .setNickName(let nickName):
            newState.nickName = nickName
        case .showError(let error):
            newState.isShowError = error
        }

        return newState
    }
}
