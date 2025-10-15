import DomainInterface

import ReactorKit
import RxSwift

public final class SetCharacterReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case dismissWithSave
        case error
    }

    public enum Action {
        case viewWillAppear
        case backButtonTapped
        case applyButtonTapped
        case inputLevel(Int?)
        case inputRole(Job?)
    }

    public enum Mutation {
        case setJobList(jobList: [Job])
        case setButtonEnabled(Bool)
        case setLevelValid(Bool?)
        case setLevel(Int?)
        case setRole(Job?)
        case navigateTo(route: Route)
    }

    public struct State {
        @Pulse var route: Route = .none

        var level: Int?
        var job: Job?
        var isButtonEnabled: Bool = false
        var isLevelValid: Bool?
        var jobList: [Job] = []
    }

    // MARK: - properties
    public var initialState: State
    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase
    var disposeBag = DisposeBag()

    // MARK: - init
    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchJobListUseCase.execute()
                .map { response in
                    .setJobList(jobList: response.jobList)
                }
                .catchAndReturn(.navigateTo(route: .error))
        case .backButtonTapped:
            return Observable.just(.navigateTo(route: .dismiss))
        case .applyButtonTapped:
            guard let level = currentState.level,
                  let job = currentState.job else { return Observable.just(.navigateTo(route: .error)) }
            return updateUserInfoUseCase.execute(level: level, selectedJobID: job.id)
                .andThen(Observable.just(.navigateTo(route: .dismissWithSave)))
                .catchAndReturn(.navigateTo(route: .error))
        case .inputLevel(let level):
            let changeLevel = Observable.just(Mutation.setLevel(level))
            let validateButton = checkEmptyUseCase.execute(level: level, job: currentState.job?.name)
                .map(Mutation.setButtonEnabled)
            let validateLevel = checkValidLevelUseCase.execute(level: level)
                .map(Mutation.setLevelValid)
            return .merge(changeLevel, validateButton, validateLevel)
        case .inputRole(let job):
            return checkEmptyUseCase.execute(level: currentState.level, job: job?.name)
                .map { isValid in
                    [.setRole(job), .setButtonEnabled(isValid)]
                }
                .flatMap { Observable.from($0) }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setJobList(let jobList):
            newState.jobList = jobList
        case .setButtonEnabled(let isEnabled):
            newState.isButtonEnabled = isEnabled
        case .setLevelValid(let isValid):
            newState.isLevelValid = isValid
        case .setLevel(let level):
            newState.level = level
        case .setRole(let job):
            newState.job = job
        case .navigateTo(let route):
            newState.route = route
        }

        return newState
    }
}
