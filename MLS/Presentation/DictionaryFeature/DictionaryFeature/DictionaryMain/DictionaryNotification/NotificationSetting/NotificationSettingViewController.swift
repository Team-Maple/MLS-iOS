import UIKit

import BaseFeature
import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class NotificationSettingViewController: BaseViewController, View {
    public typealias Reactor = NotificationSettingReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let mainView = NotificationSettingView()

    public override init() {
        super.init()
    }

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension NotificationSettingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension NotificationSettingViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        isBottomTabbarHidden = true
    }

    func createTabLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getNotificationLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
public extension NotificationSettingViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        mainView.header.leftButton.rx.tap
            .map { Reactor.Action.backbuttonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in return reactor.pulse(\.$route) }
            .withUnretained(self)
            .subscribe { (owner, route) in
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
