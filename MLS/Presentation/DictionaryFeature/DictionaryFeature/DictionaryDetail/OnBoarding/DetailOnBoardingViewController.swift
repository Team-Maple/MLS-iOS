import UIKit

import BaseFeature
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift

class DetailOnBoardingViewController: BaseViewController, View {
    public typealias Reactor = DetailOnBoardingReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    public var mainView = DetailOnBoardingView()

    public override init() {
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension DetailOnBoardingViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        view.backgroundColor = .textColor.withAlphaComponent(0.9)
    }
}

extension DetailOnBoardingViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.closeButton.rx.tap
            .map { Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidLoad
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
