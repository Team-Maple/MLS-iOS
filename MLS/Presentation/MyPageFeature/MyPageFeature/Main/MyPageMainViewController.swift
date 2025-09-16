import UIKit

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

    // MARK: - Components
    private let mainView = MyPageMainView()

    // MARK: - Init
    public init(setProfileFactory: SetProfileFactory) {
        self.setProfileFactory = setProfileFactory
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
        view.backgroundColor = .neutral100
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

    private func bindUserActions(reactor: Reactor) {}

    private func bindState(reactor: Reactor) {
        rx.viewDidAppear
            .take(1)
            .flatMapLatest { _ in reactor.pulse(\.$route) }
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
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Delegate
extension MyPageMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 5
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
            ) as? MyPageMainCell else { return UICollectionViewCell() }

            cell.inject(input: MyPageMainCell.Input(image: .checkmark, name: "익명의 오무라이스케챱"))
            cell.onSetProfileTap = { [weak self] in
                self?.reactor?.action.onNext(.editButtonTapped)
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
                cell.inject(input: MyPageListCell.Input(title: item.description, isHeader: false))
            }

            return cell

        default:
            return UICollectionViewCell()
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 디자이너 문의 필요
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
