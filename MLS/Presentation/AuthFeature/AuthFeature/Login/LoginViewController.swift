import UIKit

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class LoginViewController: BaseViewController, View {
    public typealias Reactor = LoginReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    public let routeToHome = PublishRelay<Void>()

    private let mainView: LoginView

    private let termsAgreementsFactory: TermsAgreementFactory

    public init(termsAgreementsFactory: TermsAgreementFactory) {
        self.mainView = LoginView()
        self.termsAgreementsFactory = termsAgreementsFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension LoginViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground

        if let navigationController = navigationController,
           navigationController.viewControllers.count > 1 {
            mainView.header.leftButton.isHidden = false
        } else {
            mainView.header.leftButton.isHidden = true
        }
    }
}

public extension LoginViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.kakaoLoginButton.rx.controlEvent(.touchDown)
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.kakaoLoginButton.backgroundColor = .init(hexCode: "#E5CE00")
            }
            .disposed(by: disposeBag)

        mainView.kakaoLoginButton.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.kakaoLoginButton.backgroundColor = .init(hexCode: "#FEE500")
            }
            .disposed(by: disposeBag)

        mainView.appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.appleLoginButton.rx.controlEvent(.touchDown)
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.appleLoginLabel.textColor = .init(hexCode: "#E5E5E5")
            }
            .disposed(by: disposeBag)

        mainView.appleLoginButton.rx.controlEvent([.touchUpInside, .touchUpOutside, .touchCancel])
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.mainView.appleLoginLabel.textColor = .whiteMLS
            }
            .disposed(by: disposeBag)

        mainView.guestLoginButton.rx.tap
            .map { Reactor.Action.guestLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.header.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .observe(on: MainScheduler.instance)
            .map { $0.platform }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, platform in
                owner.mainView.update(loginPlatform: platform)
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .termsAgreements(let credential, let platform):
                    let controller = owner.termsAgreementsFactory.make(credential: credential, platform: platform)
                    owner.navigationController?.pushViewController(controller, animated: true)
                case .home:
                    owner.routeToHome.accept(())
                case .error:
                    DispatchQueue.main.async {
                        let controller = BaseErrorViewController()
                        owner.present(controller, animated: true)
                    }
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
