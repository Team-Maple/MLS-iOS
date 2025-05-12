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
    func bind(reactor: Reactor) { }
}
