import UIKit

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public class TermsAgreementViewController: UIViewController, View {
    
    public typealias Reactor = TermsAgreementReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private var mainView = TermsAgreementView()
}

// MARK: - Life Cycle
extension TermsAgreementViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.setupContstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension TermsAgreementViewController {
    func addViews() {
        self.view.addSubview(mainView)
    }

    func setupContstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
    }
}

public extension TermsAgreementViewController {
    func bind(reactor: Reactor) {
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
    }
}
