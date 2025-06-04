import DomainInterface

import ReactorKit
internal import RxCocoa
internal import RxSwift

public final class OnBoardingInputReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case notification
    }

    public enum Action {
        case backButtonTapped
        case inputLevel(Int?)
        case inputRole(String?)
        case cancelOnBoarding
        case nextButtonTapped
    }

    public enum Mutation {
        case moveToPreScene
        case changeLevel(Int?)
        case changeRole(String?)
        case moveToHomeScene
        case moveToNextScene
        case setButtonEnabled(Bool)
        case setLevelValid(Bool?)
    }

    public struct State {
        @Pulse var route: Route = .none

        var level: Int?
        var role: String?
        var isButtonEnabled: Bool = false
        var isLevelValid: Bool?
    }

    // MARK: - properties
    public var initialState: State
    public var checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    public var checkValidLevelUseCase: CheckValidLevelUseCase
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase, checkValidLevelUseCase: CheckValidLevelUseCase) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            return Observable.just(.moveToPreScene)
        case .inputLevel(let level):
            let changeLevel = Observable.just(Mutation.changeLevel(level))
            let validateButton = checkEmptyUseCase.excute(level: level, role: currentState.role)
                .map(Mutation.setButtonEnabled)
            let validateLevel = checkValidLevelUseCase.excute(level: level)
                .map(Mutation.setLevelValid)
            return .merge(changeLevel, validateButton, validateLevel)
        case .inputRole(let role):
            return checkEmptyUseCase.excute(level: currentState.level, role: role)
                .map { isValid in
                    [.changeRole(role), .setButtonEnabled(isValid)]
                }
                .flatMap { Observable.from($0) }
        case .cancelOnBoarding:
            return Observable.just(.moveToHomeScene)
        case .nextButtonTapped:
            return Observable.just(.moveToNextScene)
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .moveToPreScene:
            newState.route = .dismiss
        case .changeLevel(let level):
            newState.level = level
        case .changeRole(let role):
            newState.role = role
        case .moveToHomeScene:
            newState.route = .home
        case .moveToNextScene:
            newState.route = .notification
        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
        case .setLevelValid(let isValid):
            newState.isLevelValid = isValid
        }

        return newState
    }
}
