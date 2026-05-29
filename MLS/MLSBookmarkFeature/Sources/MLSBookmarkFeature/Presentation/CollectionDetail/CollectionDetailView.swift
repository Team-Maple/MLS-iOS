import MLSDesignSystem
import SnapKit
import UIKit

final class CollectionDetailView: UIView {
    private enum Constant {
        static let topMargin: CGFloat = 12
        static let collectionViewMargin: CGFloat = 24
    }

    let navigation: NavigationBar
    let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        return view
    }()
    let listCollectionView: UICollectionView = {
        UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }()
    let emptyContainerView = UIView()
    let emptyView = CollectionDetailEmptyView()

    init(navTitle: String) {
        self.navigation = NavigationBar(type: .collection(navTitle))
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private extension CollectionDetailView {
    func addViews() {
        addSubview(navigation)
        addSubview(spacer)
        addSubview(listCollectionView)
        addSubview(emptyContainerView)
        emptyContainerView.addSubview(emptyView)
    }

    func setupConstraints() {
        navigation.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        spacer.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Constant.topMargin)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(spacer.snp.bottom).offset(Constant.collectionViewMargin)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        emptyContainerView.snp.makeConstraints { make in
            make.top.equalTo(navigation.snp.bottom).offset(Constant.collectionViewMargin)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureUI() {
        navigation.backgroundColor = .whiteMLS
        backgroundColor = .neutral100
        emptyContainerView.backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}

extension CollectionDetailView {
    func isEmptyData(isEmpty: Bool) {
        listCollectionView.isHidden = isEmpty
        emptyContainerView.isHidden = !isEmpty
    }

    func setName(name: String) {
        navigation.setTitle(title: name)
    }
}
