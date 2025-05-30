import os
import UIKit

import AuthFeatureInterface
import BaseFeature
import DesignSystem

import ReactorKit
internal import RxCocoa
import RxKeyboard
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

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension OnBoardingInputViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
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
        setKeyboard()
    }

    func setKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let safeAreaBottomInset = self.view.safeAreaInsets.bottom
                let adjustedInset = keyboardHeight > 0 ? keyboardHeight - safeAreaBottomInset + OnBoardingInputView.Constant.bottomInset : OnBoardingInputView.Constant.bottomInset
                self.mainView.nextButtonBottomConstraint?.update(inset: adjustedInset)
            })
            .disposed(by: disposeBag)
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
            .map { text -> Int? in
                Int(text)
            }
            .map { Reactor.Action.inputLevel($0) }
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
            .subscribe { _, level in
                if let level = level {
                    os_log("input level: %d", level)
                }
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.role }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { _, role in
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
                guard let isLevelValid = isLevelValid else { return }
                owner.mainView.inputBox.setType(type: isLevelValid ? InputBoxType.edit : InputBoxType.error)
                owner.mainView.errorMessage.isHidden = isLevelValid
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isButtonEnabled }
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
