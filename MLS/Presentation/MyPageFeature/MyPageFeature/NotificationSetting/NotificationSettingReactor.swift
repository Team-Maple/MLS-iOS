import DomainInterface
import ReactorKit

public final class NotificationSettingReactor: Reactor {
    // MARK: - Reactor
    public enum Route {
        case none
        case dismiss
        case setting
    }

    public enum Action {
        case viewWillAppear
        case appWillEnterForeground
        case backButtonTapped
        case eventViewSwitch(Bool)
        case noticeViewSwitch(Bool)
        case patchNoteViewSwitch(Bool)
        case pushGuideViewTapped
    }

    public enum Mutation {
        case setAuthorized(Bool)
        case toNavigate(Route)
        case setEventNotification(Bool)
        case setNoticeNotification(Bool)
        case setPatchNoteNotification(Bool)
    }

    public struct State {
        @Pulse var route = Route.none
        var authorized = false
        var isAgreeEventNotification = false
        var isAgreeNoticeNotification = false
        var isAgreePatchNoteNotification = false
    }

    public var initialState: State
    private let disposeBag = DisposeBag()

    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase

    init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase) {
        self.initialState = .init()
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .appWillEnterForeground:
            return checkNotificationPermissionUseCase.execute()
                .asObservable()
                .map { Mutation.setAuthorized($0) }
        case .backButtonTapped:
            return .just(.toNavigate(.dismiss))
        case .eventViewSwitch(let isAgree):
            return updateNotificationAgreementUseCase.execute(noticeAgreement: currentState.isAgreeNoticeNotification, patchNoteAgreement: currentState.isAgreePatchNoteNotification, eventAgreement: isAgree)
                .andThen(.just(.setEventNotification(isAgree)))
        case .noticeViewSwitch(let isAgree):
            return updateNotificationAgreementUseCase.execute(noticeAgreement: isAgree, patchNoteAgreement: currentState.isAgreePatchNoteNotification, eventAgreement: currentState.isAgreeEventNotification)
                .andThen(.just(.setNoticeNotification(isAgree)))
        case .patchNoteViewSwitch(let isAgree):
            return updateNotificationAgreementUseCase.execute(noticeAgreement: currentState.isAgreeNoticeNotification, patchNoteAgreement: isAgree, eventAgreement: currentState.isAgreeEventNotification)
                .andThen(.just(.setPatchNoteNotification(isAgree)))
        case .pushGuideViewTapped:
            return .just(.toNavigate(.setting))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setAuthorized(let authorized):
            newState.authorized = authorized
        case .toNavigate(let route):
            newState.route = route
        case .setEventNotification(let isAgree):
            newState.isAgreeEventNotification = isAgree
        case .setNoticeNotification(let isAgree):
            newState.isAgreeNoticeNotification = isAgree
        case .setPatchNoteNotification(let isAgree):
            newState.isAgreePatchNoteNotification = isAgree
        }

        return newState
    }
}
