import UIKit

import AuthFeatureInterface
import BaseFeature
import MyPageFeatureInterface

import ReactorKit
import RxSwift
import SnapKit

public final class MyPageMainViewController: BaseViewController, View {
    // MARK: - Type
    enum Constant {
        static let bottomHeight: CGFloat = 64
    }

    public typealias Reactor = MyPageMainReactor

    // MARK: - Properties
    public var disposeBag = DisposeBag()

    private let setProfileFactory: SetProfileFactory
    private let customerSupportFactory: CustomerSupportFactory
    private let notificationSettingFactory: NotificationSettingFactory
    private let setCharacterFactory: SetCharacterFactory
    private let loginFactory: LoginFactory

    // MARK: - Components
    private let mainView = MyPageMainView()

    // MARK: - Init
    public init(setProfileFactory: SetProfileFactory, customerSupportFactory: CustomerSupportFactory, notificationSettingFactory: NotificationSettingFactory, setCharacterFactory: SetCharacterFactory, loginFactory: LoginFactory) {
        self.setProfileFactory = setProfileFactory
        self.customerSupportFactory = customerSupportFactory
        self.notificationSettingFactory = notificationSettingFactory
        self.setCharacterFactory = setCharacterFactory
        self.loginFactory = loginFactory
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
private extension MyPageMainViewController {
    func addViews() {
        view.addSubview(mainView)
    }

    func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constant.bottomHeight)
        }
    }

    func configureUI() {
        mainView.mainCollectionView.collectionViewLayout = createLayout()
        mainView.mainCollectionView.delegate = self
        mainView.mainCollectionView.dataSource = self
        mainView.mainCollectionView.register(MyPageMainCell.self, forCellWithReuseIdentifier: MyPageMainCell.identifier)
        mainView.mainCollectionView.register(MyPageListCell.self, forCellWithReuseIdentifier: MyPageListCell.identifier)
    }

    func createLayout() -> UICollectionViewLayout {
        let layoutFactory = LayoutFactory()

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return layoutFactory.getMyPageMainLayout().build()
            case 1:
                return layoutFactory.getMyPageSettingLayout().build()
            default:
                return layoutFactory.getMyPageSupportLayout().build()
            }
        }
        layout.register(SettingBackgroundView.self, forDecorationViewOfKind: SettingBackgroundView.identifier)
        layout.register(SupportBackgroundView.self, forDecorationViewOfKind: SupportBackgroundView.identifier)
        return layout
    }
}

// MARK: - Bind
extension MyPageMainViewController {
    public func bind(reactor: Reactor) {
        bindUserActions(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindUserActions(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: Reactor) {
        reactor.state
            .map { $0.profile }
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .bind { owner, _ in
                owner.mainView.mainCollectionView.reloadData()
            }
            .disposed(by: disposeBag)

        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, route in
                switch route {
                case .edit:
                    let viewController = owner.setProfileFactory.make()
                    if let viewController = viewController as? SetProfileViewController {
                        viewController.didReturn
                            .withUnretained(self)
                            .subscribe(onNext: { _, isUpdate in
                                if isUpdate {
                                    ToastFactory.createToast(message: "프로필이 업데이트 되었어요.")
                                }
                            })
                            .disposed(by: owner.disposeBag)
                    }
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .characterInfoSetting:
                    let viewController = owner.setCharacterFactory.make()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .event:
                    let viewController = owner.customerSupportFactory.make(type: .event)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .notice:
                    let viewController = owner.customerSupportFactory.make(type: .announcement)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .patchNode:
                    let viewController = owner.customerSupportFactory.make(type: .patchNote)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .policy:
                    let viewController = owner.customerSupportFactory.make(type: .terms)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .notificationSetting:
                    guard let reactor = owner.reactor,
                          let profile = reactor.currentState.profile else { return }
                    let viewController = owner.notificationSettingFactory.make(isAgreeEventNotification: profile.eventAgreement, isAgreeNoticeNotification: profile.noticeAgreement, isAgreePatchNoteNotification: profile.patchNoteAgreement)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .login:
                    let viewController = owner.loginFactory.make(exitRoute: .pop)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension MyPageMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return reactor.currentState.menus[0].count + 1
        default:
            return reactor.currentState.menus[1].count + 1
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyPageMainCell.identifier,
                for: indexPath
            ) as? MyPageMainCell,
                let reactor = reactor else { return UICollectionViewCell() }

            let profile = reactor.currentState.profile
            cell.inject(
                input: MyPageMainCell.Input(
                    imageUrl: profile?.profileUrl ?? "",
                    name: profile?.nickname ?? "",
                    isLogin: profile != nil
                )
            )
            cell.onSetProfileTap = { [weak self] in
                self?.reactor?.action.onNext(.profileButtonTapped)
            }
            return cell

        case 1, 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyPageListCell.identifier,
                for: indexPath
            ) as? MyPageListCell,
                let reactor = reactor else { return UICollectionViewCell() }

            let headerTitle: String
            switch indexPath.section {
            case 1: headerTitle = "설정"
            default: headerTitle = "고객 지원"
            }

            if indexPath.row == 0 {
                cell.inject(input: MyPageListCell.Input(title: headerTitle, isHeader: true))
            } else {
                // index.row == 0은 제목
                let item = reactor.currentState.menus[indexPath.section - 1][indexPath.row - 1]
                switch item {
                case .setCharacterInfo(let .some(profile)):
                    if let level = profile.level {
                        cell.inject(input: MyPageListCell.Input(title: profile.jobName, isHeader: false, addLevel: profile.level))
                    } else {
                        cell.inject(input: MyPageListCell.Input(title: item.description, isHeader: false))
                    }
                default:
                    cell.inject(input: MyPageListCell.Input(title: item.description, isHeader: false))
                }
            }

            return cell

        default:
            return UICollectionViewCell()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return } // section 0은 프로필 셀

        let row = indexPath.row
        guard row > 0 else { return } // row 0은 header

        // 메뉴 항목 가져오기
        guard let menu = reactor?.currentState.menus[indexPath.section - 1][row - 1] else { return }
        // 액션 발생
        reactor?.action.onNext(.menuItemTapped(menu))
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 디자이너 문의 필요
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
