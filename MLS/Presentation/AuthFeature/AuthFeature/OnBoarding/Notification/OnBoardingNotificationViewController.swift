import os
import UIKit

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class OnBoardingNotificationViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = OnBoardingNotificationReactor
    private let onBoardingModalFactory: OnBoardingModalFactory

    // MARK: - Components
    public var disposeBag = DisposeBag()

    private var mainView = OnBoardingNotificationView()

    public init(factory: OnBoardingModalFactory) {
        self.onBoardingModalFactory = factory
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension OnBoardingNotificationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension OnBoardingNotificationViewController {
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
private extension OnBoardingNotificationViewController {}

// MARK: - Bind
public extension OnBoardingNotificationViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .home:
                    os_log("moveToHome")
                case .modal:
                    let modalViewController = owner.onBoardingModalFactory.make()
                    owner.presentModal(modalViewController)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
