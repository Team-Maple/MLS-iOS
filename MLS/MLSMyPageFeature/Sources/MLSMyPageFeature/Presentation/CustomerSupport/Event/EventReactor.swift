import ReactorKit

import MLSMyPageFeatureInterface

public final class EventReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
    }

    public enum Action {
        case loadMore
        case selectTab(Int)
        case itemTapped(Int)
    }

    public enum Mutation {
        case setAlarms([AlarmResponse], hasMore: Bool, reset: Bool)
        case setLoading(Bool)
        case setIndex(Int)
    }

    public struct State {
        var alarms = [AlarmResponse]()
        var selectedIndex = 0
        var hasMore = false
        var isLoading = false
    }

    // MARK: - Properties
    public var initialState: State
    private let disposeBag = DisposeBag()
    private let alarmRepository: AlarmRepository

    public init(alarmRepository: AlarmRepository) {
        self.initialState = .init()
        self.alarmRepository = alarmRepository
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTab(index):
            let fetchObservable = (index == 0
                                   ? alarmRepository.fetchOngoingEvents(cursor: nil, pageSize: 20)
                                   : alarmRepository.fetchOutdatedEvents(cursor: nil, pageSize: 20))
                .map { paged -> Mutation in
                    .setAlarms(paged.items, hasMore: paged.hasMore, reset: true)
                }
                .catch { error -> Observable<Mutation> in
                    print("Fetch error: \(error)")
                    return .just(.setLoading(false))
                }

            return .concat([
                .just(.setIndex(index)),
                .just(.setLoading(true)),
                fetchObservable,
                .just(.setLoading(false))
            ])

        case .loadMore:
            guard currentState.hasMore, !currentState.isLoading else { return .empty() }
            let lastCursor = currentState.alarms.last?.id

            return .concat([
                .just(.setLoading(true)),
                (currentState.selectedIndex == 0 ? alarmRepository.fetchOngoingEvents(cursor: lastCursor, pageSize: 20) : alarmRepository.fetchOutdatedEvents(cursor: lastCursor, pageSize: 20))
                    .map { paged in
                        .setAlarms(paged.items, hasMore: paged.hasMore, reset: false)
                    },
                .just(.setLoading(false))
            ])
        case let .itemTapped(index):
            return alarmRepository.setRead(alarmLink: currentState.alarms[index].link)
                .andThen(.empty())
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setIndex(index):
            newState.selectedIndex = index
        case let .setAlarms(newAlarms, hasMore, reset):
            if reset {
                newState.alarms = newAlarms
            } else {
                newState.alarms.append(contentsOf: newAlarms)
            }
            newState.hasMore = hasMore

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }

        return newState
    }
}
