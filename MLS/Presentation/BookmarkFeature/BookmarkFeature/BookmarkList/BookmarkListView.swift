import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class BookmarkListView: UIView {
    // MARK: - Type
    enum Constant {
        static let filterInset: CGFloat = 6
        static let sortButtonHeight: CGFloat = 32
        static let iconSize: CGFloat = 24
        static let stackViewSpacing: CGFloat = 12
        static let topMargin: CGFloat = 12
        static let nonFilterTopMargin: CGFloat = 20
        static let cellSpacing: CGFloat = 10
        static let cellWidth: CGFloat = 343
        static let cellHeight: CGFloat = 104
        static let horizontalMargin: CGFloat = 16
        static let bottomInset: CGFloat = 64
    }

    // MARK: - Components
    public let editButton = TextButton()
    
    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private lazy var filterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [editButton, UIView(), sortButton, filterButton])
        view.axis = .horizontal
//        view.spacing = Constant.stackViewSpacing
        view.alignment = .fill
        return view
    }()

    public lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "가나다 순"), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "arrowDropdown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    public lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "필터"), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    public let emptyView = BookmarkEmptyView()

    // MARK: - Init
    init(isFilterHidden: Bool) {
        super.init(frame: .zero)
        addViews()
        setupConstraints(isFilterHidden: isFilterHidden)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension BookmarkListView {
    func addViews() {
        addSubview(filterStackView)
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
                make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            }

            listCollectionView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }

        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func configureUI() {
        backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}

extension BookmarkListView {
    func updateFilter(sortType: SortType?) {
        filterStackView.isHidden = isHidden
        if let sortType = sortType {
            sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: sortType.rawValue, color: .textColor), for: .normal)
        }
    }

    func selectFilter(selectedType: SortType) {
        sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: selectedType.rawValue, color: .primary700), for: .normal)
        sortButton.tintColor = .primary700
    }
    
    func checkEmptyData(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        filterStackView.isHidden = isEmpty
        sortButton.isHidden = isEmpty
        filterButton.isHidden = isEmpty
        editButton.isHidden = isEmpty
        listCollectionView.isHidden = isEmpty
    }
}
