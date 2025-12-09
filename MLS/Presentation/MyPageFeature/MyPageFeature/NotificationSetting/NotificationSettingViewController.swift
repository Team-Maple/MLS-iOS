import UIKit

import BaseFeature
import DomainInterface

import ReactorKit
import RxSwift

final class NotificationSettingViewController: BaseViewController, View, UNUserNotificationCenterDelegate {
    typealias Reactor = NotificationSettingReactor

    public var disposeBag = DisposeBag()

    // MARK: - Properties

    // MARK: - UI Components
    private let mainView = NotificationSettingView()

    // MARK: - Init
    init(reactor: NotificationSettingReactor) {
        super.init()
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension NotificationSettingViewController {
    func setupUI() {
        isBottomTabbarHidden = true
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

// MARK: - Notification Authorization
private extension NotificationSettingViewController {
    func checkNotificationAuthorization() {
        guard let reactor = reactor else { return }

        NotificationPermissionManager.shared.getStatus { status in
            switch status {
            case .authorized, .provisional:
                reactor.action.onNext(.updateAuthorization(true))
            case .denied:
                reactor.action.onNext(.updateAuthorization(false))
            case .notDetermined:
                NotificationPermissionManager.shared.requestIfNeeded { granted in
                    reactor.action.onNext(.updateAuthorization(granted))
                }
            default:
                reactor.action.onNext(.updateAuthorization(false))
            }
        }
    }
}

// MARK: - Reactor Binding
extension NotificationSettingViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .take(1)
            .do(onNext: { [weak self] _ in
                self?.checkNotificationAuthorization()
            })
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .map { _ in Reactor.Action.appWillEnterForeground }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.eventView.switchButton.rx.isOn
            .skip(1)
            .map { Reactor.Action.eventViewSwitch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.noticeView.switchButton.rx.isOn
            .skip(1)
            .map { Reactor.Action.noticeViewSwitch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.patchNoteView.switchButton.rx.isOn
            .skip(1)
            .map { Reactor.Action.patchNoteViewSwitch($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.pushGuideView.changeButton.rx.tap
            .map { Reactor.Action.pushGuideViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.authorized }
            .withUnretained(self)
            .subscribe { owner, authorized in
                owner.mainView.setViews(authorized: authorized)
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isAgreeEventNotification }
            .distinctUntilChanged()
            .bind(to: mainView.eventView.switchButton.rx.isOn)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isAgreeNoticeNotification }
            .distinctUntilChanged()
            .bind(to: mainView.noticeView.switchButton.rx.isOn)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isAgreePatchNoteNotification }
            .distinctUntilChanged()
            .bind(to: mainView.patchNoteView.switchButton.rx.isOn)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .setting:
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
