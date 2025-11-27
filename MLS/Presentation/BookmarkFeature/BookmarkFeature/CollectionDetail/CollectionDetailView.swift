import UIKit

import DesignSystem

import SnapKit

final class CollectionDetailView: UIView {
    // MARK: - Type
    enum Constant {
        static let topMargin: CGFloat = 12
        static let collectionViewMargin: CGFloat = 24
    }

    // MARK: - Components
    public let navigation: NavigationBar

    public let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteMLS
        return view
    }()

    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    public let emptyContainerView = UIView()
    public let emptyView = CollectionDetailEmptyView()

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

// MARK: - Methods
extension CollectionDetailView {
    func isEmptyData(isEmpty: Bool) {
        listCollectionView.isHidden = isEmpty
        emptyContainerView.isHidden = !isEmpty
    }

    func setName(name: String) {
        navigation.setTitle(title: name)
    }
}
