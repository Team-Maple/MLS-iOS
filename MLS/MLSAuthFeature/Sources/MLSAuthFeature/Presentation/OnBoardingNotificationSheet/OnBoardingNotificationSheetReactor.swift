import UIKit
import UserNotifications

import MLSAuthFeatureInterface

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

    private let authRepository: AuthAPIRepository

    // MARK: - init
    public init(
        selectedLevel: Int,
        selectedJobID: Int,
        authRepository: AuthAPIRepository
    ) {
        self.initialState = State(selectedLevel: selectedLevel, selectedJobID: selectedJobID)
        self.authRepository = authRepository
    }

    // MARK: - Reactor Methods
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .appWillEnterForeground:
            return Single<Bool>.create { single in
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    let isAuthorized = settings.authorizationStatus == .authorized
                        || settings.authorizationStatus == .provisional
                    single(.success(isAuthorized))
                }
                return Disposables.create()
            }
            .asObservable()
            .map { .setLocalNotification($0) }
        case .toggleSwitchButton(let isAgree):
            return .just(.setRemoteNotification(isAgree))
        case .setButtonTapped:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            return .just(.navigateTo(route: .setting))
        case .applyButtonTapped:
            return authRepository.updateUserInfo(level: currentState.selectedLevel, selectedJobID: currentState.selectedJobID)
                .andThen(authRepository.updateNotificationAgreement(
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
