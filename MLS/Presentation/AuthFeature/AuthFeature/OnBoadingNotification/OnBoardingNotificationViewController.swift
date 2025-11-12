import UIKit
import UserNotifications

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class OnBoardingNotificationViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = OnBoardingNotificationReactor

    public var disposeBag = DisposeBag()

    private let onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory

    // MARK: - Components

    private var mainView = OnBoardingNotificationView()

    public init(onBoardingNotificationSheetFactory: OnBoardingNotificationSheetFactory) {
        self.onBoardingNotificationSheetFactory = onBoardingNotificationSheetFactory
        super.init()
    }

    @available(*, unavailable)
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
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .notificationAlert:
                    let viewController = owner.onBoardingNotificationSheetFactory.make(selectedLevel: reactor.currentState.selectedLevel, selectedJobID: reactor.currentState.selectedJobID)
                    owner.presentModal(viewController)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
