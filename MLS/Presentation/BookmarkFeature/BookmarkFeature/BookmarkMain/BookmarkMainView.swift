import BaseFeature
import DesignSystem
import DomainInterface
import SnapKit
import UIKit

final class BookmarkMainView: UIView {
    enum Constant {
        static let topMargin: CGFloat = 20
        static let pageTabHeight: CGFloat = 40
        static let bottomTabHeight: CGFloat = 64
    }

    // MARK: - Components
    public let headerView = Header(style: .main, title: "북마크")
    public let searchBar = SearchBar()

    public let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    public let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    public let emptyView = ToLoginView()

    // MARK: - Init
    public init(type: DictionaryMainViewType) {
        super.init(frame: .zero)
        setupBaseLayout(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Base Layout
private extension BookmarkMainView {
    func setupBaseLayout(type: DictionaryMainViewType) {
        switch type {
        case .search:
            addSubview(searchBar)
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview()
            }
        default:
            addSubview(headerView)
            headerView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview()
            }

            addSubview(tabCollectionView)
            addSubview(pageViewController.view)
            addSubview(emptyView)

            tabCollectionView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(Constant.pageTabHeight)
            }

            pageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(tabCollectionView.snp.bottom)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide)
                make.bottom.equalToSuperview().inset(Constant.bottomTabHeight)
            }

            emptyView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(Constant.bottomTabHeight)
            }

            tabCollectionView.isHidden = true
            pageViewController.view.isHidden = true
            emptyView.isHidden = false
        }
    }
}

// MARK: - Public Update
extension BookmarkMainView {
    public func updateLoginState(isLogin: Bool) {
        tabCollectionView.isHidden = !isLogin
        pageViewController.view.isHidden = !isLogin

        emptyView.isHidden = isLogin

        tabCollectionView.isUserInteractionEnabled = isLogin
        pageViewController.view.isUserInteractionEnabled = isLogin
    }
}
