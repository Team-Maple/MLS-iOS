import UIKit

import DesignSystem
import DictionaryFeatureInterface
import DomainInterface

import SnapKit

final class DictionaryMainView: UIView {

    enum Constant {
        static let topMargin: CGFloat = 20
        static let pageTabHeight: CGFloat = 40
        static let bottomTabHeight: CGFloat = 64
    }

    // MARK: - Components
    public let headerView = Header(style: .main, title: "도감")

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

    // MARK: - Init
    public init(type: DictionaryMainViewType) {
        super.init(frame: .zero)
        addViews(type: type)
        setupConstraints(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryMainView {
    func addViews(type: DictionaryMainViewType) {
        switch type {
        case .search:
            addSubview(searchBar)
        default:
            addSubview(headerView)
        }
        addSubview(tabCollectionView)
        addSubview(pageViewController.view)
    }

    func setupConstraints(type: DictionaryMainViewType) {
        switch type {
        case .search:
            searchBar.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview()
            }

            tabCollectionView.snp.makeConstraints { make in
                make.top.equalTo(searchBar.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(Constant.pageTabHeight)
            }

            pageViewController.view.snp.makeConstraints { make in
                make.top.equalTo(tabCollectionView.snp.bottom)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
            }
        default:
            headerView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalToSuperview()
            }

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
        }
    }
}
