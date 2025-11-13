import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit

public class SetCharacterViewController: BaseViewController, View {
    // MARK: - Properties
    public typealias Reactor = SetCharacterReactor

    public var disposeBag = DisposeBag()

    // MARK: - Components

    private var mainView = SetCharacterView()
}

// MARK: - Life Cycle
public extension SetCharacterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension SetCharacterViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {
        setupKeyboard()
    }

    func setupKeyboard() {
        setupKeyboard(inset: CharacterInputView.Constant.bottomInset) { [weak self] height in
            self?.mainView.nextButtonBottomConstraint?.update(inset: height)
        }
    }
}

// MARK: - Bind
public extension SetCharacterViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nextButton.rx.tap
            .map { Reactor.Action.applyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.inputBox.textField.rx.text.orEmpty
            .map { text -> Int? in
                Int(text)
            }
            .map { Reactor.Action.inputLevel($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.dropDownBox.onItemSelected = { [weak self] job in
            guard let self = self else { return }
            self.reactor?.action.onNext(.inputRole(.init(name: job.name, id: job.id)))
        }

        mainView.headerView.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.state
            .map { $0.jobList }
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, list in
                owner.mainView.dropDownBox.items = list.map { .init(name: $0.name, id: $0.id) }
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

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .dismissWithSave:
                    owner.navigationController?.popViewController(animated: true)
                case .error:
                    let errorViewController = BaseErrorViewController()
                    owner.present(errorViewController, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
