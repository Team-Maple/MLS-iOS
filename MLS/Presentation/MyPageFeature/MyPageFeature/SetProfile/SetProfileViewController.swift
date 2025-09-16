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

    // MARK: - Init
    public init(selectImageFactory: SelectImageFactory) {
        self.selectImageFactory = selectImageFactory
        super.init()
        mainView.setName(name: "익명의 오무라이스케챱")
        mainView.setImage(image: .add)
        mainView.setPlatform(platform: .kakao)
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
        configureUI()
    }
}

// MARK: - Setup
private extension SetProfileViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        guard let reactor = reactor else { return }
        view.backgroundColor = reactor.currentState.setProfileState == .edit ? .neutral100 : .whiteMLS
    }
}

// MARK: - Bind
extension SetProfileViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
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
    }

    private func bindState(reactor: Reactor) {
        reactor.state
            .map(\.setProfileState)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, state in
                owner.mainView.setState(state: state)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter(\.isEditingNickName)
            .map(\.nickName)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, nickName in
                owner.mainView.setCount(count: nickName.count)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isShowError)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, isShowError in
                owner.mainView.setError(isError: isShowError)
            })
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .imageBottomSheet:
                    let viewController = owner.selectImageFactory.make()
                    owner.presentModal(viewController)
                case .dismiss:
                    owner.didReturn.accept(false)
                    owner.navigationController?.popViewController(animated: true)
                case .dismissWithUpdate:
                    owner.didReturn.accept(true)
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
