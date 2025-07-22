import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class BookmarkDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let TopMargin: CGFloat = 12
    }

    // MARK: - Components
    public let navigation: NavigationBar
    
    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    public let emptyContainerView = UIView()
    public let emptyView = BookmarkDetailEmptyView()

    // MARK: - Init
    init(navTitle: String) {
        self.navigation = NavigationBar(type: .collection(navTitle))
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension BookmarkDetailView {
    func addViews() {
        addSubview(navigation)
        addSubview(listCollectionView)
        addSubview(emptyContainerView)
        emptyContainerView.addSubview(emptyView)
    }

    func setupConstraints() {
        navigation.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(Constant.TopMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyContainerView.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(Constant.TopMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        emptyContainerView.backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}

// MARK: - Methods
extension BookmarkDetailView {
    func isEmptyData(isEmpty: Bool) {
        listCollectionView.isHidden = !isEmpty
        emptyContainerView.isHidden = isEmpty
    }
}
