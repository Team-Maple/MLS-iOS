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
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    func configureUI() {
        isBottomTabbarHidden = true
        guard let reactor = reactor else { return }
        mainView.setEmpty(isEmpty: reactor.currentState.isAgreeNotification)

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
        mainView.header.leftButton.rx.tap
            .map { Reactor.Action.backbuttonTapped }
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
            .subscribe { owner, route in
                switch route {
                case .dismiss:
                    owner.navigationController?.popViewController(animated: true)
                case .setting:
                    let viewController = owner.notificationSettingFactory.make()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
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
        cell.inject(input: DictionaryNotificationCell.Input(title: item.title, subTitle: item.date, isChecked: item.isChecked))
        return cell
    }
}
