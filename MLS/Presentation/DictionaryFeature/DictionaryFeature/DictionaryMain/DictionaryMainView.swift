import UIKit
import SnapKit
import DesignSystem

final class DictionaryMainView: UIView {
    
    enum Constant {
        static let pageTabHeight: CGFloat = 40
    }
    
    // MARK: - Components
    let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let divider = DividerView()
    
    let pageViewController = UIPageViewController(
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
        addSubview(tabCollectionView)
        addSubview(divider)
        addSubview(pageViewController.view)
    }
    
    private func setupConstraints() {
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constant.pageTabHeight)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
