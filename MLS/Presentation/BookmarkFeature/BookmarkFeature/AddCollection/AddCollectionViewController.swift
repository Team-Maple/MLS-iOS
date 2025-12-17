import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DesignSystem

import ReactorKit
import RxKeyboard
import RxSwift
import SnapKit

public final class AddCollectionViewController: BaseViewController, View {
    public typealias Reactor = AddCollectionModalReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    public let dismissed = PublishSubject<String>()

    // MARK: - Components
    private let mainView = AddCollectionView()
    private let addCollectionContainer = UIView()
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()

    // MARK: - Init
    override public init() {
        super.init()
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGestures()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboard()
        presentWithAnimation()
    }
}

// MARK: - Setup
private extension AddCollectionViewController {
    func setupViews() {
        view.backgroundColor = .clear

        view.addSubview(dimmedBackgroundView)
        view.addSubview(addCollectionContainer)
        addCollectionContainer.addSubview(mainView)

        addCollectionContainer.layer.cornerRadius = 16
        addCollectionContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addCollectionContainer.backgroundColor = .whiteMLS

        addCollectionContainer.isHidden = true
        mainView.isHidden = false
    }

    func setupConstraints() {
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        addCollectionContainer.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        dimmedBackgroundView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismissWithAnimation(withData: false)
            })
            .disposed(by: disposeBag)
    }

    func setupKeyboard() {
        setupKeyboard(inset: AddCollectionView.Constant.buttonBottomMargin) { [weak self] height in
            self?.mainView.addButtonBottomConstraint?.update(inset: height)
        }
    }
}

// MARK: - Bind
extension AddCollectionViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        mainView.inputTextField.rx.text
            .distinctUntilChanged()
            .map { Reactor.Action.inputTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.completeButton.rx.tap
            .map { Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: Reactor) {
        reactor.state
            .map(\.inputText)
            .take(1)
            .withUnretained(self)
            .bind(onNext: { owner, text in
                owner.mainView.updateTextField(text: text)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isError)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isError in
                owner.mainView.setError(isError: isError)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.collection)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, collection in
                owner.mainView.checkIsEmptyCollection(collection: collection)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isButtonEnabled)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.mainView.setButtonEnabled(isEnabled: isEnabled)
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.dismissWithAnimation(withData: false) {
                        owner.dismiss(animated: false)
                    }
                case .dismissWithData:
                    owner.dismissWithAnimation(withData: true) {
                        owner.dismiss(animated: false)
                    }
                case .updateError:
                    ToastFactory.createToast(message: "컬렉션 수정에 실패했어요. 다시 시도해주세요.")
                case .createError:
                    ToastFactory.createToast(message: "컬렉션 생성에 실패했어요. 다시 시도해주세요.")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Animation
private extension AddCollectionViewController {
    func presentWithAnimation() {
        dimmedBackgroundView.alpha = 0
        dimmedBackgroundView.isHidden = false
        addCollectionContainer.isHidden = false
        addCollectionContainer.transform = CGAffineTransform(translationX: 0, y: 400)

        UIView.animate(withDuration: 0.25) {
            self.dimmedBackgroundView.alpha = 1
            self.addCollectionContainer.transform = .identity
        }

        mainView.setError(isError: false)
        mainView.setButtonEnabled(isEnabled: false)
        mainView.inputTextField.becomeFirstResponder()
    }

    func dismissWithAnimation(withData: Bool, completion: (() -> Void)? = nil) {
        mainView.endEditing(true)

        UIView.animate(withDuration: 0.25, animations: {
            self.dimmedBackgroundView.alpha = 0
            self.addCollectionContainer.transform = CGAffineTransform(translationX: 0, y: 400)
        }, completion: { _ in
            self.addCollectionContainer.isHidden = true
            self.dimmedBackgroundView.isHidden = true

            if withData {
                guard let text = self.mainView.inputTextField.text else { return }
                self.dismissed.onNext((text))
                self.dismissed.onCompleted()
            }

            self.dismiss(animated: false, completion: completion)
        })
    }
}
