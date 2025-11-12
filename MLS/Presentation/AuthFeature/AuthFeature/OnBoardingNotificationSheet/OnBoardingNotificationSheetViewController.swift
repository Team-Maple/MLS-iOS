import UIKit

import BaseFeature
import DesignSystem
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class OnBoardingNotificationSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = OnBoardingNotificationSheetReactor

    public var disposeBag = DisposeBag()

    // MARK: - Properties

    private let dictionaryMainViewFactory: DictionaryMainViewFactory

    // MARK: - Components
    private var mainView = OnBoardingNotificationSheetView()

    init(dictionaryMainViewFactory: DictionaryMainViewFactory) {
        self.dictionaryMainViewFactory = dictionaryMainViewFactory
        super.init()
    }
}

// MARK: - Life Cycle
public extension OnBoardingNotificationSheetViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
    }
}

// MARK: - SetUp
private extension OnBoardingNotificationSheetViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension OnBoardingNotificationSheetViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.header.firstIconButton.rx.tap
            .map { Reactor.Action.cancelButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.skipButton.rx.tap
            .map { Reactor.Action.skipButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.settingButton.rx.tap
            .map { Reactor.Action.setButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.applyButton.rx.tap
            .map { Reactor.Action.applyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.notificationToggleBox.toggle.rx.isOn
            .map { Reactor.Action.toggleSwitchButton($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.isAgreeLocalNotification }
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.setUI(isAgree: isAgree)
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .observe(on: MainScheduler.instance)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                DispatchQueue.main.async {
                    switch route {
                    case .dismiss:
                        owner.dismissCurrentModal()
                    case .home:
                        let viewController = owner.dictionaryMainViewFactory.make()
                        let navigationController = UINavigationController(rootViewController: viewController)
                        AppRouter.setRoot(navigationController)
                    case .setting:
                        guard let url = URL(string: UIApplication.openSettingsURLString),
                              UIApplication.shared.canOpenURL(url) else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    default:
                        break
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
