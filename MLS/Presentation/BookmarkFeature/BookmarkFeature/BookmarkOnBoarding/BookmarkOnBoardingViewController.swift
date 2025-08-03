import UIKit

import BaseFeature

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class BookmarkOnBoardingViewController: BaseViewController, View {
    public typealias Reactor = BookmarkOnBoardingReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = BookmarkOnBoardingView()

    // MARK: - Init
    override public init() {
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
        configureUI()
    }
}

// MARK: - Setup
private extension BookmarkOnBoardingViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureUI() {}
}

// MARK: - Bind
extension BookmarkOnBoardingViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        mainView.backButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.nextButton.rx.tap
            .map { Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe(onNext: { owner, route in
                switch route {
                case .dismiss:
                    owner.dismiss(animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.step)
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { owner, step in
                owner.mainView.configureUI(type: step)
            })
            .disposed(by: disposeBag)
    }
}
