import UIKit

import AuthFeatureInterface
import BaseFeature

import ReactorKit
internal import RxCocoa
internal import RxSwift
internal import SnapKit

public final class LoginViewController: BaseViewController, View {

    public typealias Reactor = LoginReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let mainView: LoginView

    private let termsAgreementsFactory: TermsAgreementFactory

    public init(isRelogin: Bool, termsAgreementsFactory: TermsAgreementFactory) {
        self.mainView = LoginView(isRelogin: isRelogin)
        self.termsAgreementsFactory = termsAgreementsFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension LoginViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.addViews()
        self.setupConstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension LoginViewController {
    func addViews() {
        self.view.addSubview(mainView)
    }

    func setupConstraints() {
        self.mainView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
    }
}

public extension LoginViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.guestLoginButton.rx.tap
            .map { Reactor.Action.guestLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .termsAgreements:
                    let controller = owner.termsAgreementsFactory.make()
                    owner.navigationController?.pushViewController(controller, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
