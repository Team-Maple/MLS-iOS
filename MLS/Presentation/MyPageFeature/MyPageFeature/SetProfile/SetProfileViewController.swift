import UIKit

import BaseFeature
import MyPageFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class SetProfileViewController: BaseViewController, View {
    // MARK: - Type
    enum Constant {
        static let bottomHeight: CGFloat = 64
    }

    public typealias Reactor = SetProfileReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    var didReturn = PublishRelay<Bool>()
    private var selectImageFactory: SelectImageFactory

    // MARK: - Components
    private let mainView = SetProfileView()
    private let topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        return view
    }()

    // MARK: - Init
    public init(selectImageFactory: SelectImageFactory) {
        self.selectImageFactory = selectImageFactory
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
    }
}

// MARK: - Setup
private extension SetProfileViewController {
    func addViews() {
        view.addSubview(topBackgroundView)
        view.addSubview(mainView)
    }

    func setupConstraints() {
        topBackgroundView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Bind
extension SetProfileViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.editButton.rx.tap
            .map { Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.imageTap
            .map { Reactor.Action.showBottomSheet }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nickNameInputBox.textField.rx.text.orEmpty
            .map { Reactor.Action.inputNickName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nickNameInputBox.textField.rx.controlEvent(.editingDidBegin)
            .map { Reactor.Action.beginEditingNickName }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.logoutButton.rx.tap
            .map { Reactor.Action.logoutButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.onCancelTap
            .map { Reactor.Action.withdrawButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: Reactor) {
        reactor.state
            .map(\.setProfileState)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, state in
                owner.view.backgroundColor = state == .edit ? .whiteMLS : .neutral100
                owner.mainView.setCountHidden(state: state)
                owner.mainView.setState(state: state)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap(\.profile)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, profile in
                owner.mainView.setImage(imageUrl: profile.profileUrl)
                owner.mainView.setPlatform(platform: profile.platform)
                owner.mainView.nickNameInputBox.textField.text = profile.nickname
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap(\.nickName)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, nickname in
                owner.mainView.setName(name: nickname)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter(\.isEditingNickName)
            .compactMap(\.nickName)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, nickname in
                owner.mainView.setCount(count: nickname.count)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isShowError)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, isShowError in
                owner.mainView.setError(isError: isShowError)
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .imageBottomSheet:
                    let viewController = owner.selectImageFactory.make()

                    if let viewController = viewController as? UIViewController {
                        viewController.rx
                            .methodInvoked(#selector(UIViewController.viewDidDisappear))
                            .take(1)
                            .map { _ in Reactor.Action.viewWillAppear }
                            .bind(to: reactor.action)
                            .disposed(by: owner.disposeBag)
                    }

                    owner.presentModal(viewController)
                case .dismiss:
                    owner.didReturn.accept(false)
                    owner.navigationController?.popViewController(animated: true)
                case .dismissWithUpdate:
                    owner.didReturn.accept(true)
                    owner.navigationController?.popViewController(animated: true)
                case .logoutAlert:
                    GuideAlertFactory.showAuthAlert(type: .logout, ctaAction: {
                        reactor.action.onNext(.logout)
                    })
                case .withdrawAlert:
                    GuideAlertFactory.showAuthAlert(type: .withdraw, ctaAction: {
                        reactor.action.onNext(.withdraw)
                    })
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
