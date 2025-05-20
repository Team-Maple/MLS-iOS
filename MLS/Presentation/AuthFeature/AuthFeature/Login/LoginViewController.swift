import UIKit

internal import SnapKit
internal import RxCocoa
internal import RxSwift
import ReactorKit

public final class LoginViewController: UIViewController, View {
    
    public typealias Reactor = LoginReactor
    
    // MARK: - Properties
    public var disposeBag = DisposeBag()
    
    private var mainView = LoginView()
}

// MARK: - Life Cycle
extension LoginViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addViews()
        self.setupContstraints()
        self.configureUI()
    }
}

// MARK: - SetUp
private extension LoginViewController {
    func addViews() {
        self.view.addSubview(mainView)
    }

    func setupContstraints() {
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
    }
}
