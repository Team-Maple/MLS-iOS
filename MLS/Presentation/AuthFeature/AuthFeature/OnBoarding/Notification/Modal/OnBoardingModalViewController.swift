import UIKit

import BaseFeature

import ReactorKit
internal import RxCocoa
internal import RxSwift
internal import SnapKit

final class OnBoardingModalViewController: BaseViewController, View, ModalPresentable {
    // MARK: - Properties
    typealias Reactor = OnBoardingModalReactor

    var disposeBag = DisposeBag()

    var modalHeight: CGFloat? = nil
    var modalStyle: ModalStyle = .modal

    private var mainView = OnBoardingModalView()
}

// MARK: - Life Cycle
extension OnBoardingModalViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension OnBoardingModalViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() { }
}

extension OnBoardingModalViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.agreeButton.rx.tap
            .map { Reactor.Action.agreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.disagreeButton.rx.tap
            .map { Reactor.Action.disagreeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$route)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
