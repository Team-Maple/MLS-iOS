import MLSRecommendationFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

final class RecommendationMainReactor: Reactor {

    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case informationButtonTapped
    }

    enum Mutation {
        case setProfile(UserProfile)
        case setJobName(String)
        case setRecommendations([RecommendationMap])
        case setLoading(Bool)
        case informationButtonToggle
    }

    struct State {
        var profile: UserProfile?
        var jobName: String = ""
        var recommendations: [RecommendationMap] = []
        var isLoading: Bool = false
        var informationButtonIsOn: Bool = false
    }

    // MARK: - Properties
    var initialState: State
    var disposeBag = DisposeBag()

    private let repository: RecommendationRepository

    // MARK: - Init
    init(repository: RecommendationRepository) {
        self.repository = repository
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let fetchAll = repository.fetchProfile()
                .flatMap { [weak self] profile -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    let setProfile = Observable.just(Mutation.setProfile(profile))
                    let setJobName: Observable<Mutation>
                    if let jobId = profile.jobId {
                        setJobName = repository.fetchJobName(jobId: jobId)
                            .map { Mutation.setJobName($0) }
                            .catch { _ in .empty() }
                    } else {
                        setJobName = .empty()
                    }
                    let setRecommendations: Observable<Mutation>
                    if let level = profile.level, level >= 1, let jobId = profile.jobId {
                        setRecommendations = repository.fetchRecommendations(level: level, jobId: jobId, limit: 5)
                            .map { Mutation.setRecommendations($0) }
                            .catch { _ in .empty() }
                    } else {
                        setRecommendations = .empty()
                    }
                    let parallelRequests = Observable.merge([setJobName, setRecommendations])
                    return Observable.concat([setProfile, parallelRequests])
                }
                .catch { _ in .empty() }

            return Observable.concat([
                .just(.setLoading(true)),
                fetchAll,
                .just(.setLoading(false))
            ])

        case .informationButtonTapped:
            return .just(.informationButtonToggle)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setProfile(let profile):
            newState.profile = profile
        case .setJobName(let jobName):
            newState.jobName = jobName
        case .setRecommendations(let maps):
            newState.recommendations = maps
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .informationButtonToggle:
            newState.informationButtonIsOn.toggle()
        }
        return newState
    }
}
