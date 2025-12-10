import DomainInterface

import ReactorKit

public final class SetProfileReactor: Reactor {
    // MARK: - Route
    public enum Route {
        case none
        case dismiss
        case dismissWithUpdate
        case imageBottomSheet
        case logoutAlert
        case withdrawAlert
    }

    // MARK: - Action
    public enum Action {
        case viewWillAppear
        case backButtonTapped
        case editButtonTapped
        case logoutButtonTapped
        case withdrawButtonTapped
        case showBottomSheet
        case inputNickName(String)
        case beginEditingNickName
        case logout
        case withdraw
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
        case setNickName(String)
        case setProfile(MyPageResponse?)
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
        var isShowError = false
        var isEditingNickName = false
        var profile: MyPageResponse?
        var nickName = ""
    }

    // MARK: - Properties
    public var initialState = State(setProfileState: .normal)

    private let checkNickNameUseCase: CheckNickNameUseCase
    private let updateNickNameUseCase: UpdateNickNameUseCase
    private let logoutUseCase: LogoutUseCase
    private let withdrawUseCase: WithdrawUseCase
    private let fetchProfileUseCase: FetchProfileUseCase

    // MARK: - Init
    public init(checkNickNameUseCase: CheckNickNameUseCase, updateNickNameUseCase: UpdateNickNameUseCase, logoutUseCase: LogoutUseCase, withdrawUseCase: WithdrawUseCase, fetchProfileUseCase: FetchProfileUseCase) {
        self.checkNickNameUseCase = checkNickNameUseCase
        self.updateNickNameUseCase = updateNickNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .showBottomSheet:
            return .just(.toNavigate(.imageBottomSheet))
        case .inputNickName(let nickName):
            return checkNickNameUseCase.execute(nickName: nickName)
                .map { isValid in
                    [.setNickName(nickName), .showError(!isValid)]
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
                if currentState.isShowError {
                    return .empty()
                } else {
                    return updateNickNameUseCase.execute(nickName: currentState.nickName)
                        .flatMap { profile in
                            Observable.concat([
                                .just(.setProfile(profile)),
                                .just(.completeEditting)
                            ])
                        }
                }
            case .normal:
                return .just(.beginEditting)
            }
        case .logoutButtonTapped:
            return Observable.just(.toNavigate(.logoutAlert))
        case .withdrawButtonTapped:
            return Observable.just(.toNavigate(.withdrawAlert))
        case .logout:
            return logoutUseCase.execute()
                .andThen(.just(.toNavigate(.dismiss)))
        case .withdraw:
            return withdrawUseCase.execute()
                .andThen(.just(.toNavigate(.dismiss)))
        case .viewWillAppear:
            return fetchProfileUseCase.execute()
                .map { Mutation.setProfile($0)}
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case .showError(let error):
            newState.isShowError = error
        case .beginSetText(let isEditing):
            newState.isEditingNickName = isEditing
        case .cancelEditting:
            newState.setProfileState = .normal
        case .beginEditting:
            newState.setProfileState = .edit
        case .completeEditting:
            newState.route = .dismissWithUpdate
        case .setProfile(let profile):
            newState.profile = profile
            newState.nickName = profile?.nickname ?? ""
        case .setNickName(let nickname):
            newState.nickName = nickname
        }

        return newState
    }
}
