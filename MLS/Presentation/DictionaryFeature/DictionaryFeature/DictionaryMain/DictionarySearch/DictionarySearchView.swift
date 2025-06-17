import UIKit

import DesignSystem

import SnapKit

final class DictionarySearchView: UIView {
    // MARK: - Type
    enum Constant {
        static let searchBarTopMargin: CGFloat = 18
        static let collectionViewTopMargin: CGFloat = 20
        static let horizontalMargin: CGFloat = 16
        static let collectionViewSpacing: CGFloat = 10
    }
    
    // MARK: - Components
    public let searchBar = SearchBar()
    
    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension DictionarySearchView {
    func addViews() {
        addSubview(searchBar)
        addSubview(searchCollectionView)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.searchBarTopMargin)
            make.horizontalEdges.equalToSuperview()
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Constant.collectionViewTopMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .clearMLS
    }
}
