import UIKit

import BaseFeature
import DomainInterface

import ReactorKit
import RxKeyboard
import RxSwift

public final class AddCollectionViewController: BaseViewController, ModalPresentable, View {
    public typealias Reactor = AddCollectionReactor
    public var modalHeight: CGFloat? = nil

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView: AddCollectionView

    override public init() {
        self.mainView = AddCollectionView()
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.inputTextField.becomeFirstResponder()
    }
}

// MARK: - SetUp
private extension AddCollectionViewController {
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
                let adjustedInset = keyboardHeight > 0 ? keyboardHeight - safeAreaBottomInset + AddCollectionView.Constant.buttonBottomMargin : AddCollectionView.Constant.buttonBottomMargin
                self.mainView.addButtonBottomConstraint?.update(inset: adjustedInset)

            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Bind
extension AddCollectionViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.inputTextField.rx.text
            .map { Reactor.Action.inputText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.mainView.inputTextField.text.map { Reactor.Action.completeButtonTapped($0) }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissCurrentModal()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isError)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, isError in
                owner.mainView.setError(isError: isError)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isButtonEnabled)
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, isEnabled in
                owner.mainView.setButtonEnabled(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
}
