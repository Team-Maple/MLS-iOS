import UIKit

import BaseFeature

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

    // MARK: - Components
    private let mainView = MyPageMainView()

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

    private func bindState(reactor: Reactor) {}
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageMainCell.identifier, for: indexPath) as? MyPageMainCell else { return UICollectionViewCell() }
            cell.inject(input: MyPageMainCell.Input(image: .checkmark, name: "익명의 오무라이스케챱"))
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageListCell.identifier, for: indexPath) as? MyPageListCell else { return UICollectionViewCell() }
            cell.inject(input: MyPageListCell.Input(title: "제목", isHeader: indexPath.row == 0))
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageListCell.identifier, for: indexPath) as? MyPageListCell else { return UICollectionViewCell() }
            cell.inject(input: MyPageListCell.Input(title: "이벤트", isHeader: indexPath.row == 0))
            return cell
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 디자이너 문의 필요
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }

//    public func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//        switch indexPath.section {
//        case 1:
//            let view = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: MyPageHeaderView.identifier,
//                for: indexPath
//            ) as! MyPageHeaderView
//            view.inject(title: "설정")
//            return view
//        case 2:
//            let view = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: MyPageHeaderView.identifier,
//                for: indexPath
//            ) as! MyPageHeaderView
//            view.inject(title: "고객 지원")
//            return view
//        default:
//            return UICollectionReusableView()
//        }
//    }
}
