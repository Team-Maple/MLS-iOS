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
        case toggleSwitchButton(Bool)
        case setButtonTapped
        case cancelButtonTapped
        case applyButtonTapped
        case skipButtonTapped
        case updateAuthorization(Bool)
        case appWillEnterForeground
    }

    public enum Mutation {
        case navigateTo(route: Route)
        case setLocalNotification(Bool)
        case setRemoteNotification(Bool)
        case setAuthorized(Bool)
    }

    public struct State {
        @Pulse var route: Route = .none
        var selectedLevel: Int
        var selectedJobID: Int
        var isAgreeLocalNotification = false
        var isAgreeRemoteNotification = true
    }

    // MARK: - properties
    public var initialState: State
    var disposeBag = DisposeBag()

    private let checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase
    private let openNotificationSettingUseCase: OpenNotificationSettingUseCase
    private let updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase
    private let updateUserInfoUseCase: UpdateUserInfoUseCase

    // MARK: - init
    public init(
        selectedLevel: Int,
        selectedJobID: Int,
        checkNotificationPermissionUseCase: CheckNotificationPermissionUseCase,
        openNotificationSettingUseCase: OpenNotificationSettingUseCase,
        updateNotificationAgreementUseCase: UpdateNotificationAgreementUseCase,
        updateUserInfoUseCase: UpdateUserInfoUseCase
    ) {
        self.initialState = State(selectedLevel: selectedLevel, selectedJobID: selectedJobID)
        self.checkNotificationPermissionUseCase = checkNotificationPermissionUseCase
        self.openNotificationSettingUseCase = openNotificationSettingUseCase
        self.updateNotificationAgreementUseCase = updateNotificationAgreementUseCase
        self.updateUserInfoUseCase = updateUserInfoUseCase
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .appWillEnterForeground:
            return checkNotificationPermissionUseCase.execute()
                .asObservable()
                .map { .setLocalNotification($0) }
        case .toggleSwitchButton(let isAgree):
            return .just(.setRemoteNotification(isAgree))
        case .setButtonTapped:
            openNotificationSettingUseCase.execute()
            return .just(.navigateTo(route: .setting))
        case .applyButtonTapped:
            return updateUserInfoUseCase.execute(level: currentState.selectedLevel, selectedJobID: currentState.selectedJobID)
                .andThen(updateNotificationAgreementUseCase.execute(
                    noticeAgreement: true,
                    patchNoteAgreement: true,
                    eventAgreement: true
                ))
                .andThen(Observable.just(.navigateTo(route: .home)))
                .catchAndReturn(.navigateTo(route: .dismiss))
        case .cancelButtonTapped:
            return .just(.navigateTo(route: .dismiss))
        case .skipButtonTapped:
            return .just(.navigateTo(route: .home))
        case .updateAuthorization(let authorized):
            return .just(.setAuthorized(authorized))
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
        case let .setAuthorized(isAuthorized):
            newState.isAgreeLocalNotification = isAuthorized
        }

        return newState
    }
}
