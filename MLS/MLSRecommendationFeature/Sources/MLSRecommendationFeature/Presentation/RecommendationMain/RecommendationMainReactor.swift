import MLSRecommendationFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

final class RecommendationMainReactor: Reactor {

    // MARK: - Reactor
    enum Action {
        case viewDidLoad
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
        var profile: UserProfile? = nil
        var jobName: String = ""
        var recommendations: [RecommendationMap] = []
        var isLoading: Bool = false
        var informationButtonIsOn: Bool = false
    }

    // MARK: - Properties
    var initialState: State
    var disposeBag = DisposeBag()

    private let repository: RecommendationRepository
    private let level: Int
    private let jobId: Int

    // MARK: - Init
    init(
        repository: RecommendationRepository,
        level: Int,
        jobId: Int
    ) {
        self.repository = repository
        self.level = level
        self.jobId = jobId
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fetchProfile = repository.fetchProfile()
                .flatMap { [weak self] profile -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    let setProfile = Observable.just(Mutation.setProfile(profile))
                    guard let jobId = profile.jobId else { return setProfile }
                    let setJobName = self.repository.fetchJobName(jobId: jobId)
                        .map { Mutation.setJobName($0) }
                        .catch { _ in .empty() }
                    return Observable.concat([setProfile, setJobName])
                }
                .catch { _ in .empty() }

            let fetchRecommendations = repository.fetchRecommendations(level: level, jobId: jobId, limit: 5)
                .map { Mutation.setRecommendations($0) }
                .catch { _ in .empty() }

            return Observable.concat([
                .just(.setLoading(true)),
                Observable.merge(fetchProfile, fetchRecommendations),
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
