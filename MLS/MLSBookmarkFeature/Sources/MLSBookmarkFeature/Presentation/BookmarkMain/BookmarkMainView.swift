import UIKit

import MLSBookmarkFeatureInterface
import MLSCore
import MLSDesignSystem
import MLSDictionaryFeatureInterface

import SnapKit

final class BookmarkMainView: UIView {
    enum Constant {
        static let topMargin: CGFloat = 20
        static let pageTabHeight: CGFloat = 40
        static let bottomTabHeight: CGFloat = 64
    }

    let headerView = Header(style: .main, title: "북마크")

    let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    let emptyView = ToLoginView(type: .bookmark)

    init(type: DictionaryMainViewType, bottomInset: CGFloat = Constant.bottomTabHeight) {
        super.init(frame: .zero)
        setupBaseLayout(type: type, bottomInset: bottomInset)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookmarkMainView {
    func setupBaseLayout(type: DictionaryMainViewType, bottomInset: CGFloat) {
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
            make.bottom.equalToSuperview().inset(bottomInset)
        }

        emptyView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomInset)
        }

        tabCollectionView.isHidden = true
        pageViewController.view.isHidden = true
        emptyView.isHidden = false
    }
}

extension BookmarkMainView {
    func updateLoginState(isLogin: Bool) {
        tabCollectionView.isHidden = !isLogin
        pageViewController.view.isHidden = !isLogin
        emptyView.isHidden = isLogin
        tabCollectionView.isUserInteractionEnabled = isLogin
        pageViewController.view.isUserInteractionEnabled = isLogin
    }
}
