import DomainInterface

import ReactorKit

public final class MyPageMainReactor: Reactor {
    // MARK: - Type
    public enum MyPageMenu {
        case setAlarm
        case setCharacterInfo(MyPageResponse?)
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

        var requiresLogin: Bool {
            switch self {
            case .setAlarm, .setCharacterInfo:
                return true
            default:
                return false
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
        case login
    }

    // MARK: - Action
    public enum Action {
        case viewWillAppear
        case profileButtonTapped
        case menuItemTapped(MyPageMenu)
    }

    // MARK: - Mutation
    public enum Mutation {
        case toNavigate(Route)
        case setProfile(MyPageResponse?)
    }

    // MARK: - State
    public struct State {
        @Pulse var route: Route?
        var menus: [[MyPageMenu]] = [
            [
                .setAlarm,
                .setCharacterInfo(nil)
            ], [
                .showEvent,
                .showNotice,
                .showPatchNode,
                .showPolicy
            ]
        ]
        var profile: MyPageResponse?
    }

    // MARK: - Properties
    public var initialState = State()

    private let fetchProfileUseCase: FetchProfileUseCase

    // MARK: - Init
    public init(fetchProfileUseCase: FetchProfileUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .profileButtonTapped:
            if currentState.profile != nil {
                return .just(.toNavigate(.edit))
            } else {
                return .just(.toNavigate(.login))
            }
        case .menuItemTapped(let menu):
            if currentState.profile == nil, menu.requiresLogin {
                return .just(.toNavigate(.login))
            } else {
                return .just(.toNavigate(menu.route))
            }
        case .viewWillAppear:
            return fetchProfileUseCase.execute()
                .map { .setProfile($0) }
                .catch { error in
                    print(error)
                    return .just(.setProfile(nil))
                }
        }
    }

    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .toNavigate(let route):
            newState.route = route
        case .setProfile(let profile):
            newState.profile = profile
            newState.menus[0][1] = .setCharacterInfo(profile)
        }

        return newState
    }
}
