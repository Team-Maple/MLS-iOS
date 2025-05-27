import os
import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
internal import RxCocoa
internal import RxSwift
internal import SnapKit

public class OnBoardingInputViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = OnBoardingInputReactor
    private let factory: OnBoardingFactory

    // MARK: - Components
    public var disposeBag = DisposeBag()

    private var mainView = OnBoardingInputView()
    
    public init(factory: OnBoardingFactory) {
        self.factory = factory
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension OnBoardingInputViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - SetUp
private extension OnBoardingInputViewController {
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
private extension OnBoardingInputViewController {}

// MARK: - Bind
public extension OnBoardingInputViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.inputBox.textField.rx.text.orEmpty
            .map { Reactor.Action.inputLevel((Int($0))) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.dropDownBox.inputBox.textField.rx.text.orEmpty
            .map { Reactor.Action.inputRole($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map { $0.level }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, level in
                if let level = level {
                    os_log("input level: %d", level)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.role }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, role in
                if let role = role {
                    os_log("input role: %@", role as NSString)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLevelValid }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, isLevelValid in
                owner.mainView.inputBox.setType(type: isLevelValid ? InputBoxType.edit : InputBoxType.error)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isButtonEnabled }
            .distinctUntilChanged()
            .bind(to: mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .home:
                    os_log("moveToHome")
                case .notification:
                    let vc = owner.factory.make()
                    owner.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
