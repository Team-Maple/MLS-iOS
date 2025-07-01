import UIKit

import DesignSystem

import SnapKit

final class DictionaryListView: UIView {
    // MARK: - Type
    enum Constant {
        static let filterInset: CGFloat = 6
        static let iconSize: CGFloat = 24
        static let stackViewSpacing: CGFloat = 12
        static let topMargin: CGFloat = 12
        static let nonFilterTopMargin: CGFloat = 20
        static let filterTopMargin: CGFloat = 6
        static let cellSpacing: CGFloat = 10
        static let cellWidth: CGFloat = 343
        static let cellHeight: CGFloat = 104
        static let horizontalMargin: CGFloat = 16
    }

    // MARK: - Components
    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private lazy var filterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sortButton, filterButton])
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    public lazy var sortButton: UIButton = {
        let button = UIButton()
        button.addSubview(sortLabel)
        button.addSubview(sortIcon)

        sortLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(Constant.filterInset)
        }

        sortIcon.snp.makeConstraints { make in
            make.leading.equalTo(sortLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(sortLabel)
            make.size.equalTo(Constant.iconSize)
        }

        return button
    }()

    private let sortLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .caption, text: "가나다 순")
        return label
    }()

    private let sortIcon: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "arrowDown")
        return view
    }()

    public lazy var filterButton: UIButton = {
        let button = UIButton()
        button.addSubview(filterLabel)
        button.addSubview(filterIcon)

        filterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(Constant.filterInset)
        }

        filterIcon.snp.makeConstraints { make in
            make.leading.equalTo(filterLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(filterLabel)
            make.size.equalTo(Constant.iconSize)
        }

        return button
    }()

    private let filterLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .caption, text: "필터")
        return label
    }()

    private let filterIcon: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "filter")
        return view
    }()
    
    public let emptyView = DictionaryListEmptyView()

    // MARK: - Init
    init(isFilterHidden: Bool) {
        super.init(frame: .zero)
        addViews(isFilterHidden: isFilterHidden)
        setupConstraints(isFilterHidden: isFilterHidden)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SetUp
private extension DictionaryListView {
    func addViews(isFilterHidden: Bool) {
        if !isFilterHidden {
            addSubview(filterStackView)
        }
        addSubview(listCollectionView)
        addSubview(emptyView)
    }

    func setupConstraints(isFilterHidden: Bool) {
        if isFilterHidden {
            listCollectionView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Constant.nonFilterTopMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        } else {
            filterStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Constant.topMargin)
                make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
            }

            listCollectionView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.filterTopMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }
        
        emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
    }

    func configureUI() {
        backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}
