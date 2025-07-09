import UIKit

import BaseFeature
import BookmarkFeatureInterface
import DesignSystem
import DomainInterface

import ReactorKit
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit

public final class BookmarkMainViewController: BaseViewController, View {
    public typealias Reactor = BookmarkMainReactor

    // MARK: - Properties
    private var onBoardingFactory: BookmarkOnBoardingFactory
    
    public var disposeBag = DisposeBag()

    // MARK: - Components
    private let mainView = BookmarkMainView()

    // MARK: - Init
    public init(onBoardingFactory: BookmarkOnBoardingFactory) {
        self.onBoardingFactory = onBoardingFactory
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

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactor?.action.onNext(.viewDidAppear)
    }
}

// MARK: - Setup
private extension BookmarkMainViewController {
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
extension BookmarkMainViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {}

    private func bindViewState(reactor: Reactor) {
        reactor.pulse(\.$route)
            .distinctUntilChanged()
            .filter { $0 == .onBoarding }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let viewController = owner.onBoardingFactory.make()
                viewController.modalPresentationStyle = .fullScreen

                viewController.rx.deallocated
                    .take(1)
                    .subscribe(onNext: {
                        reactor.action.onNext(.dismissOnboarding)
                    })
                    .disposed(by: owner.disposeBag)

                owner.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
