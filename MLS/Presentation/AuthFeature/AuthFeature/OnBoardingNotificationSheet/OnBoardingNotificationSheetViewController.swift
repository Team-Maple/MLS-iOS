import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class OnBoardingNotificationSheetViewController: BaseViewController, ModalPresentable, View {
    public var modalHeight: CGFloat?

    public typealias Reactor = OnBoardingNotificationSheetReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()
    public var onSelectedIndex: ((Int) -> Void)?

    // MARK: - Components

    private var mainView = OnBoardingNotificationSheetView()
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
            .map { Reactor.Action.toggleButton($0) }
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
        
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                case .home:
                    break
                case .setting:
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
