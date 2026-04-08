import DomainInterface

import ReactorKit
import RxSwift

public final class OnBoardingInputReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case home
        case notification
        case error
    }

    public enum Action {
        case viewWillAppear
        case backButtonTapped
        case skipButtonTapped
        case nextButtonTapped
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
    var disposeBag = DisposeBag()

    private let checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase
    private let checkValidLevelUseCase: CheckValidLevelUseCase
    private let fetchJobListUseCase: FetchJobListUseCase

    // MARK: - init
    public init(
        checkEmptyUseCase: CheckEmptyLevelAndRoleUseCase,
        checkValidLevelUseCase: CheckValidLevelUseCase,
        fetchJobListUseCase: FetchJobListUseCase
    ) {
        self.checkEmptyUseCase = checkEmptyUseCase
        self.checkValidLevelUseCase = checkValidLevelUseCase
        self.fetchJobListUseCase = fetchJobListUseCase
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
        case .skipButtonTapped:
            return Observable.just(.navigateTo(route: .home))
        case .nextButtonTapped:
               return Observable.just(.navigateTo(route: .notification))
        case .inputLevel(let level):
            let changeLevel = Observable.just(Mutation.setLevel(level))
            let validateJob = checkEmptyUseCase.execute(level: level, job: currentState.job?.name)
                .map(Mutation.setButtonEnabled)
            let validateLevel = checkValidLevelUseCase.execute(level: level)
                .map(Mutation.setLevelValid)
            return .merge(changeLevel, validateJob, validateLevel)
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
        case .setRole(let role):
            newState.job = role
        case .navigateTo(let route):
            newState.route = route
        }

        return newState
    }
}
