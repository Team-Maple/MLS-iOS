import ReactorKit

import DomainInterface

public final class AnnouncementReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
    }

    public enum Action {
        case viewWillAppear
        case loadMore
        case itemTapped(Int)
    }

    public enum Mutation {
        case setAlarms([AlarmResponse], hasMore: Bool, reset: Bool)
        case setLoading(Bool)
    }

    public struct State {
        var alarms = [AlarmResponse]()
        var hasMore = false
        var isLoading = false
    }

    // MARK: - Properties
    public var initialState: State
    private let disposeBag = DisposeBag()
    private let fetchNoticesUseCase: FetchNoticesUseCase
    private let setReadUseCase: SetReadUseCase

    public init(fetchNoticesUseCase: FetchNoticesUseCase, setReadUseCase: SetReadUseCase) {
        self.initialState = .init()
        self.fetchNoticesUseCase = fetchNoticesUseCase
        self.setReadUseCase = setReadUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                .just(.setLoading(true)),
                fetchNoticesUseCase.execute(cursor: nil, pageSize: 20)
                    .map { paged in
                        .setAlarms(paged.items, hasMore: paged.hasMore, reset: true)
                    },
                .just(.setLoading(false))
            ])
        case .loadMore:
            guard currentState.hasMore, !currentState.isLoading else { return .empty() }
            let lastCursor = currentState.alarms.last?.date
            return .concat([
                .just(.setLoading(true)),
                fetchNoticesUseCase.execute(cursor: lastCursor, pageSize: 20)
                    .map { paged in
                        .setAlarms(paged.items, hasMore: paged.hasMore, reset: false)
                    },
                .just(.setLoading(false))
            ])
        case .itemTapped(let index):
            return setReadUseCase.execute(alarmLink: currentState.alarms[index].link)
                .andThen(.empty())
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
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
