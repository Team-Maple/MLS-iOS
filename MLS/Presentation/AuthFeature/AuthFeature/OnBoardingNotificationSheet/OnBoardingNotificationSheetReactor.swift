import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift

public final class OnBoardingNotificationSheetReactor: Reactor {
    public enum Route {
        case none
        case dismiss
        case home
        case setting
    }

    // MARK: - Reactor
    public enum Action {
        case viewWillAppear
        case toggleButton(Bool)
        case setButtonTapped
        case cancelButtonTapped
        case applyButtonTapped
        case skipButtonTapped
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setLocalNotification(Bool)
        case setRemoteNotification(Bool)
    }

    public struct State {
        @Pulse var route: Route = .none
        var isAgreeLocalNotification = false
        var isAgreeRemoteNotification = true
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase

    // MARK: - init
    public init(checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase, openNotificationSettingUseCase: OpenNotificationSettingUseCase, updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase) {
        self.initialState = State()
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return checkNotificationPermissionUseCase.execute()
                .asObservable()
                .map { .setLocalNotification($0) }
        case .toggleButton(let isAgree):
            return .just(.setRemoteNotification(isAgree))
        case .setButtonTapped:
            openNotificationSettingUseCase.execute()
            return .just(.navigateTo(route: .setting))
        case .applyButtonTapped:
            return updateNotificationAgreementUseCase.execute(noticeAgreement: true, patchNoteAgreement: true, eventAgreement: true)
                .andThen(Observable.just(.navigateTo(route: .home)))
        case .cancelButtonTapped:
            return .just(.navigateTo(route: .dismiss))
        case .skipButtonTapped:
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .navigateTo(let route):
            newState.route = route
        case .setLocalNotification(let isAgree):
            newState.isAgreeLocalNotification = isAgree
        case .setRemoteNotification(let isAgree):
            newState.isAgreeRemoteNotification = isAgree
        }

        return newState
    }
}
