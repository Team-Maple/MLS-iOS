import MLSBookmarkFeatureInterface
import MLSDictionaryFeatureInterface
import MLSRecommendationFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

final class RecommendationMainReactor: Reactor {

    // MARK: - Reactor
    enum Action {
        case viewWillAppear
        case informationButtonTapped
        case toggleBookmark(mapId: Int)
        case undoLastDeletedBookmark
    }

    enum UIEvent {
        case none
        case added(RecommendationMap)
        case deleted(RecommendationMap)
    }

    enum Mutation {
        case setProfile(UserProfile)
        case setJobName(String)
        case setRecommendations([RecommendationMap])
        case setLoading(Bool)
        case informationButtonToggle
        case setLogin(Bool)
        case updateBookmarkId(mapId: Int, bookmarkId: Int?)
        case setLastDeleted(RecommendationMap?)
        case setUIEvent(UIEvent)
    }

    struct State {
        var profile: UserProfile?
        var jobName: String = ""
        var recommendations: [RecommendationMap] = []
        var isLoading: Bool = false
        var informationButtonIsOn: Bool = false
        var isLogin: Bool = false
        var lastDeleted: RecommendationMap?
        @Pulse var uiEvent: UIEvent = .none
    }

    // MARK: - Properties
    var initialState: State
    var disposeBag = DisposeBag()

    private let repository: RecommendationRepository
    private let bookmarkRepository: BookmarkRepository

    // MARK: - Init
    init(repository: RecommendationRepository, bookmarkRepository: BookmarkRepository) {
        self.repository = repository
        self.bookmarkRepository = bookmarkRepository
        self.initialState = State()
    }

    // MARK: - Reactor Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let fetchAll = repository.fetchProfile()
                .flatMap { [weak self] profile -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    let setLogin = Observable.just(Mutation.setLogin(true))
                    let setProfile = Observable.just(Mutation.setProfile(profile))
                    let setJobName: Observable<Mutation>
                    if let jobId = profile.jobId {
                        setJobName = repository.fetchJobName(jobId: jobId)
                            .map { Mutation.setJobName($0) }
                            .catch { error in
                                print("⚠️ [Recommendation] fetchJobName 실패: \(error)")
                                return .empty()
                            }
                    } else {
                        setJobName = .empty()
                    }
                    let setRecommendations: Observable<Mutation>
                    if let level = profile.level, level >= 1, let jobId = profile.jobId {
                        setRecommendations = repository.fetchRecommendations(level: level, jobId: jobId, limit: 5)
                            .map { Mutation.setRecommendations($0) }
                            .catch { error in
                                print("⚠️ [Recommendation] fetchRecommendations 실패: \(error)")
                                return .empty()
                            }
                    } else {
                        setRecommendations = .empty()
                    }
                    let parallelRequests = Observable.merge([setJobName, setRecommendations])
                    return Observable.concat([setLogin, setProfile, parallelRequests])
                }
                .catch { error in
                    print("⚠️ [Recommendation] fetchProfile 실패: \(error)")
                    return Observable.just(.setLogin(false))
                }

            return Observable.concat([
                .just(.setLoading(true)),
                fetchAll,
                .just(.setLoading(false))
            ])

        case .informationButtonTapped:
            return .just(.informationButtonToggle)

        case let .toggleBookmark(mapId):
            return handleToggleBookmark(mapId: mapId)

        case .undoLastDeletedBookmark:
            return handleUndoLastDeleted()
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
        case .setLogin(let isLogin):
            newState.isLogin = isLogin
        case let .updateBookmarkId(mapId, bookmarkId):
            if let index = newState.recommendations.firstIndex(where: { $0.mapId == mapId }) {
                let old = newState.recommendations[index]
                newState.recommendations[index] = RecommendationMap(
                    mapId: old.mapId,
                    score: old.score,
                    iconUrl: old.iconUrl,
                    nameKr: old.nameKr,
                    bookmarkId: bookmarkId
                )
            }
        case let .setLastDeleted(map):
            newState.lastDeleted = map
        case let .setUIEvent(event):
            newState.uiEvent = event
        }
        return newState
    }
}

// MARK: - Methods
private extension RecommendationMainReactor {
    func handleToggleBookmark(mapId: Int) -> Observable<Mutation> {
        guard let map = currentState.recommendations.first(where: { $0.mapId == mapId }) else {
            return .empty()
        }

        if let bookmarkId = map.bookmarkId {
            return bookmarkRepository.deleteBookmark(bookmarkId: bookmarkId)
                .flatMap { _ -> Observable<Mutation> in
                    .from([
                        .setLastDeleted(map),
                        .updateBookmarkId(mapId: mapId, bookmarkId: nil),
                        .setUIEvent(.deleted(map))
                    ])
                }
                .catch { _ in .empty() }
        } else {
            return bookmarkRepository.setBookmark(resourceId: mapId, type: .map)
                .flatMap { newBookmarkId -> Observable<Mutation> in
                    let updated = RecommendationMap(
                        mapId: map.mapId, score: map.score,
                        iconUrl: map.iconUrl, nameKr: map.nameKr,
                        bookmarkId: newBookmarkId
                    )
                    return .from([
                        .updateBookmarkId(mapId: mapId, bookmarkId: newBookmarkId),
                        .setUIEvent(.added(updated))
                    ])
                }
                .catch { _ in .empty() }
        }
    }

    func handleUndoLastDeleted() -> Observable<Mutation> {
        guard let last = currentState.lastDeleted else { return .empty() }
        return bookmarkRepository.setBookmark(resourceId: last.mapId, type: .map)
            .flatMap { newBookmarkId -> Observable<Mutation> in
                let restored = RecommendationMap(
                    mapId: last.mapId, score: last.score,
                    iconUrl: last.iconUrl, nameKr: last.nameKr,
                    bookmarkId: newBookmarkId
                )
                return .from([
                    .setLastDeleted(nil),
                    .updateBookmarkId(mapId: last.mapId, bookmarkId: newBookmarkId),
                    .setUIEvent(.added(restored))
                ])
            }
            .catch { _ in .empty() }
    }
}
