import UIKit

import BaseFeature
import AuthFeatureInterface

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class TermsAgreementViewController: BaseViewController, View {
    
    public typealias Reactor = TermsAgreementReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private let onBoardingFactory: OnBoardingFactory
    
    private var mainView = TermsAgreementView()
    
    public init(onBoardingFactory: OnBoardingFactory) {
        self.onBoardingFactory = onBoardingFactory
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
extension TermsAgreementViewController {
    public override func viewDidLoad() {
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
        
        mainView.totalAgreeButton.rx.tap
            .map { Reactor.Action.totalAgreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.oldAgreeButton.rx.tap
            .map { Reactor.Action.oldAgreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.serviceTermsAgreeButton.rx.tap
            .map { Reactor.Action.serviceTermsAgreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.personalInformationAgreeButton.rx.tap
            .map { Reactor.Action.personalInformationAgreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.marketingAgreeButton.rx.tap
            .map { Reactor.Action.marketingAgreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
            .map { $0.isOldAgree }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isAgree in
                owner.mainView.oldAgreeButton.isSelected = isAgree
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
        
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { (owner, route) in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .onBoarding:
                    let vc = owner.onBoardingFactory.make()
                    owner.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
