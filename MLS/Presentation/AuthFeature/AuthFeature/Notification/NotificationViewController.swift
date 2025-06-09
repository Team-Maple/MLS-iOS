import os
import UIKit
import UserNotifications

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class NotificationViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = NotificationReactor

    // MARK: - Components
    public var disposeBag = DisposeBag()

    private var mainView = NotificationView()
    
    private let loginFactory: LoginFactory

    public init(factory: LoginFactory) {
        self.loginFactory = factory
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension NotificationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension NotificationViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        addViews()
        setupConstraints()
    }
}

// MARK: - Private Methods
private extension NotificationViewController {}

// MARK: - Bind
public extension NotificationViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .notificationAlert:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                        DispatchQueue.main.async {
                            let loginViewController = owner.loginFactory.make(isReLogin: false)
                            if granted {
                                UIApplication.shared.registerForRemoteNotifications()
                                owner.navigationController?.setViewControllers([loginViewController], animated: true)
                            } else {
                                let alert = UIAlertController(
                                    title: "언제든 설정에서 알림을 켜거나 끄실 수 있어요.",
                                    message: nil,
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                                    owner.navigationController?.setViewControllers([loginViewController], animated: true)
                                }))
                                owner.present(alert, animated: true)
                            }
                        }
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
