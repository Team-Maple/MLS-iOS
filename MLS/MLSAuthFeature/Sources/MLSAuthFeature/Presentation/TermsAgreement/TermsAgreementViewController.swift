import UIKit

import AuthFeatureInterface
import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public class TermsAgreementViewController: BaseViewController, View {
    public typealias Reactor = TermsAgreementReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let onBoardingQuestionFactory: OnBoardingQuestionFactory

    private var mainView = TermsAgreementView()

    public init(onBoardingQuestionFactory: OnBoardingQuestionFactory) {
        self.onBoardingQuestionFactory = onBoardingQuestionFactory
        super.init()
    }

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension TermsAgreementViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension TermsAgreementViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }
}

public extension TermsAgreementViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let agreeButtons: [(button: UIButton, type: TermsAgreementReactor.AgreeType, isRightButton: Bool)] = [
            (mainView.totalAgreeButton, .total, false),
            (mainView.ageAgreeButton, .age, false),
            (mainView.ageAgreeButton.rightButton, .age, true),
            (mainView.serviceTermsAgreeButton, .serviceTerms, false),
            (mainView.serviceTermsAgreeButton.rightButton, .serviceTerms, true),
            (mainView.personalInformationAgreeButton, .personalInfo, false),
            (mainView.personalInformationAgreeButton.rightButton, .personalInfo, true),
            (mainView.marketingAgreeButton, .marketing, false),
            (mainView.marketingAgreeButton.rightButton, .marketing, true)
        ]

        agreeButtons.forEach { button, type, _ in
            button.rx.tap
                .map { Reactor.Action.toggleAgree(type: type) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }

        mainView.bottomButton.rx.tap
            .map { Reactor.Action.bottomButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map { $0.isTotalAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.totalAgreeButton.isSelected = isAgree
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isAgeAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.ageAgreeButton.isSelected = isAgree
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isServiceTermsAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.serviceTermsAgreeButton.isSelected = isAgree
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isPersonalInformationAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.personalInformationAgreeButton.isSelected = isAgree
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isMarketingAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.marketingAgreeButton.isSelected = isAgree
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.bottomButtonIsEnabled }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isEnabled in
                owner.mainView.bottomButton.isEnabled = isEnabled
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .onBoarding:
                    let questionViewController = owner.onBoardingQuestionFactory.make()
                    owner.navigationController?.setViewControllers([questionViewController], animated: true)
                case .error:
                    let errorViewController = BaseErrorViewController()
                    owner.present(errorViewController, animated: true)
                case .ageAgreement:
                    break
                case .serviceAgreement:
                    break
                case .personalAgreement:
                    break
                case .marketingAgreement:
                    break
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
