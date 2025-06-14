import UIKit

import DesignSystem

import SnapKit

final class DictionaryMainView: UIView {
    
    enum Constant {
        static let pageTabHeight: CGFloat = 40
        static let bottomTabHeight: CGFloat = 64
    }
    
    // MARK: - Components
    private let headerView = Header(style: .main, title: "도감")
    
    public let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let divider = DividerView()
    
    public let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func addViews() {
        addSubview(headerView)
        addSubview(tabCollectionView)
        addSubview(divider)
        addSubview(pageViewController.view)
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.pageTabHeight)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(Constant.bottomTabHeight)
        }
    }
}
