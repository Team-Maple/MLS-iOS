import MyPageFeatureInterface
import UIKit

import BaseFeature
import DictionaryFeatureInterface

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

public final class DictionaryNotificationViewController: BaseViewController, View {
    public typealias Reactor = DictionaryNotificationReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private var lastPagingTime: Date = .distantPast

    private var notificationSettingFactory: NotificationSettingFactory

    // MARK: - Components
    private let mainView = DictionaryNotificationView()

    public init(notificationSettingFactory: NotificationSettingFactory) {
        self.notificationSettingFactory = notificationSettingFactory
        super.init()
    }

    @available(*, unavailable)
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle
public extension DictionaryNotificationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupConstraints()
        configureUI()
    }
}

// MARK: - SetUp
private extension DictionaryNotificationViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        isBottomTabbarHidden = true

        mainView.notificationCollectionView.delegate = self
        mainView.notificationCollectionView.dataSource = self
        mainView.notificationCollectionView.register(DictionaryNotificationCell.self, forCellWithReuseIdentifier: DictionaryNotificationCell.identifier)
        mainView.notificationCollectionView.collectionViewLayout = createTabLayout()
    }

    func createTabLayout() -> UICollectionViewLayout {
        let layout = CompositionalLayoutBuilder()
            .section { _ in LayoutFactory.getNotificationLayout() }
            .build()
        return layout
    }
}

// MARK: - Bind
public extension DictionaryNotificationViewController {
    func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindViewState(reactor: reactor)
    }

    func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.header.leftButton.rx.tap
            .map { Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        mainView.header.boldTextButton.rx.tap
            .map { Reactor.Action.settingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindViewState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .setting:
                    guard let reactor = owner.reactor,
                          let profile = reactor.currentState.profile else { return }
                    let viewController = owner.notificationSettingFactory.make(isAgreeEventNotification: profile.eventAgreement, isAgreeNoticeNotification: profile.noticeAgreement, isAgreePatchNoteNotification: profile.patchNoteAgreement)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case let .notification(url):
                    let webViewController = WebViewController(urlString: url)
                    owner.present(webViewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.notifications }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, _ in
                owner.mainView.notificationCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.permission }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, permission in
                owner.mainView.setEmpty(hasPermission: permission)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension DictionaryNotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.notifications.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reactor = reactor else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DictionaryNotificationCell.identifier, for: indexPath) as? DictionaryNotificationCell else { return UICollectionViewCell() }
        let item = reactor.currentState.notifications[indexPath.row]
        cell.inject(input: DictionaryNotificationCell.Input(title: item.title, subTitle: item.date.toDisplayDateString(), isChecked: item.alreadyRead))
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let reactor = reactor else { return }
        reactor.action.onNext(.notificationTapped(index: indexPath.row))
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let now = Date()
        guard now.timeIntervalSince(lastPagingTime) > 0.5 else { return }

        guard let reactor = reactor else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            reactor.action.onNext(.loadMore)
        }
    }
}
