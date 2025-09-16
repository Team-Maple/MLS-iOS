import DomainInterface

import ReactorKit

public final class SetProfileReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case dismiss
        case dismissWithUpdate
        case imageBottomSheet
    }

    // MARK: - Action
    public enum Action {
        case backButtonTapped
        case editButtonTapped
        case showBottomSheet
        case inputNickName(String)
        case beginEditingNickName
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
        case setNickName(String)
        case showError(Bool)
        case beginSetText(Bool)
        case beginEditting
        case cancelEditting
        case completeEditting
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route = .none
        var setProfileState: SetProfileView.SetProfileState
        var nickName: String = ""
        var isShowError = false
        var isEditingNickName = false
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
            return checkNickNameUseCase.execute(nickName: nickName)
                .map { isValid in
                    [.setNickName(nickName), .showError(isValid)]
                }
                .flatMap { Observable.from($0) }
        case .beginEditingNickName:
            return .just(.beginSetText(true))
        case .backButtonTapped:
            switch currentState.setProfileState {
            case .edit:
                return .just(.cancelEditting)
            case .normal:
                return .just(.toNavigate(.dismiss))
            }
        case .editButtonTapped:
            switch currentState.setProfileState {
            case .edit:
                return .just(.completeEditting)
            case .normal:
                return .just(.beginEditting)
            }
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
        case .beginSetText(let isEditing):
            newState.isEditingNickName = isEditing
        case .cancelEditting:
            newState.setProfileState = .normal
        case .beginEditting:
            newState.setProfileState = .edit
        case .completeEditting:
            // 저장후
            newState.route = .dismissWithUpdate
        }

        return newState
    }
}
