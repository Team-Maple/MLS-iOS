import ReactorKit

import DomainInterface

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
    private let fetchOngoingEventsUseCase: FetchOngoingEventsUseCase
    private let fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase
    private let setReadUseCase: SetReadUseCase

    public init(fetchOngoingEventsUseCase: FetchOngoingEventsUseCase, fetchOutdatedEventsUseCase: FetchOutdatedEventsUseCase, setReadUseCase: SetReadUseCase) {
        self.initialState = .init()
        self.fetchOngoingEventsUseCase = fetchOngoingEventsUseCase
        self.fetchOutdatedEventsUseCase = fetchOutdatedEventsUseCase
        self.setReadUseCase = setReadUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTab(index):
            let fetchObservable = (index == 0
                ? fetchOngoingEventsUseCase.execute(cursor: nil, pageSize: 20)
                : fetchOutdatedEventsUseCase.execute(cursor: nil, pageSize: 20))
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
            let lastCursor = currentState.alarms.last?.date

            return .concat([
                .just(.setLoading(true)),
                (currentState.selectedIndex == 0 ? fetchOngoingEventsUseCase.execute(cursor: lastCursor, pageSize: 20) : fetchOutdatedEventsUseCase.execute(cursor: lastCursor, pageSize: 20))
                    .map { paged in
                        .setAlarms(paged.items, hasMore: paged.hasMore, reset: false)
                    },
                .just(.setLoading(false))
            ])
        case let .itemTapped(index):
            return setReadUseCase.execute(alarmLink: currentState.alarms[index].link)
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
