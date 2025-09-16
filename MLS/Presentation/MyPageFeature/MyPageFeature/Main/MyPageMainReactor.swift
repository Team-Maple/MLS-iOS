import ReactorKit

public final class MyPageMainReactor: Reactor {
    // MARK: - Type
    public enum MyPageMenu {
        case setAlarm
        case setCharacterInfo
        case showEvent
        case showNotice
        case showPatchNode
        case showPolicy
        
        var route: Route {
            switch self {
            case .setAlarm:
                    .notificationSetting
            case .showEvent:
                    .event
            case .showNotice:
                    .notice
            case .showPatchNode:
                    .patchNode
            case .showPolicy:
                    .policy
            case .setCharacterInfo:
                    .characterInfoSetting
            }
        }

        var description: String {
            switch self {
            case .setAlarm:
                "알림 설정"
            case .setCharacterInfo:
                "캐릭터 정보 설정"
            case .showEvent:
                "메이플랜드 이벤트"
            case .showNotice:
                "메이플랜드 공지사항"
            case .showPatchNode:
                "메이플랜드 패치노트"
            case .showPolicy:
                "약관 및 정책"
            }
        }
    }

    // MARK: - Route
    public enum Route {
        case edit
        case notificationSetting
        case characterInfoSetting
        case event
        case notice
        case patchNode
        case policy
    }

    // MARK: - Action
    public enum Action {
        case editButtonTapped
        case menuItemTapped(MyPageMenu)
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        let menus: [[MyPageMenu]] = [
            [
                .setAlarm,
                .setCharacterInfo
            ], [
                .showEvent,
                .showNotice,
                .showPatchNode,
                .showPolicy
            ]
        ]
    }

    // MARK: - Properties
    public var initialState = State()

    // MARK: - Init
    public init() {
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editButtonTapped:
            return .just(.toNavigate(.edit))
        case .menuItemTapped(let menu):
            return .just(.toNavigate(menu.route))
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        }

        return newState
    }
}
