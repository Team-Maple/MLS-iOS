import UIKit

import DesignSystem
import DomainInterface

import SnapKit

open class BaseListView: UIView {
    // MARK: - Type
    enum Constant {
        static let filterInset: CGFloat = 6
        static let filterHeight: CGFloat = 32
        static let iconSize: CGFloat = 24
        static let stackViewSpacing: CGFloat = 12
        static let topMargin: CGFloat = 12
        static let cellSpacing: CGFloat = 10
        static let cellWidth: CGFloat = 343
        static let cellHeight: CGFloat = 104
        static let horizontalMargin: CGFloat = 16
        static let bottomInset: CGFloat = 64
    }

    // MARK: - Components
    public let editButton: UIButton?
    public let listCollectionView: UICollectionView
    public let sortButton: UIButton
    public let filterButton: UIButton
    public let emptyView: DataEmptyView

    private lazy var filterStackView: UIStackView = {
        var subviews: [UIView] = []

        if let editButton = editButton {
            subviews.append(editButton)
        }
        subviews.append(UIView())
        subviews.append(sortButton)
        subviews.append(filterButton)

        let view = UIStackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        view.alignment = .fill
        return view
    }()

    // MARK: - Init
    public init(editButton: UIButton? = nil,
                sortButton: UIButton,
                filterButton: UIButton,
                emptyView: DataEmptyView,
                isFilterHidden: Bool) {
        self.editButton = editButton
        self.sortButton = sortButton
        self.filterButton = filterButton
        self.emptyView = emptyView
        self.listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

        super.init(frame: .zero)
        addViews(isFilterHidden: isFilterHidden)
        setupConstraints(isFilterHidden: isFilterHidden)
        configureUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Setup
private extension BaseListView {
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
                make.edges.equalToSuperview()
            }

            emptyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            filterStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Constant.topMargin)
                make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
                make.height.equalTo(Constant.filterHeight)
            }

            listCollectionView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }

            emptyView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }
    }

    func configureUI() {
        backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}

// MARK: - Methods
public extension BaseListView {
    func updateFilter(sortType: SortType?) {
        let hasFilter = sortType != nil
        filterStackView.isHidden = !hasFilter

        listCollectionView.snp.remakeConstraints { make in
            if hasFilter {
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            make.horizontalEdges.bottom.equalToSuperview()
        }

        if let sortType = sortType {
            sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: sortType.rawValue, color: sortButton.tintColor), for: .normal)
        }
    }

    func updateBookmarkFilter(type: DictionaryType) {
        if type == .total {
            filterButton.isHidden = true
        }
    }

    static func makeSortButton(title: String, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: title), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "lineArrowDown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.setTitleColor(tintColor, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }

    static func makeFilterButton(title: String, tintColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: title), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.setTitleColor(tintColor, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }

    func selectSort(selectedType: SortType) {
        sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: selectedType.rawValue, color: .primary700), for: .normal)
        sortButton.tintColor = .primary700
    }

    func selectFilter() {
        filterButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "필터", color: .primary700), for: .normal)
        filterButton.tintColor = .primary700
    }

    func resetFilter() {
        filterButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "필터"), for: .normal)
        filterButton.tintColor = .black
    }

    func checkEmptyData(isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        listCollectionView.isHidden = isEmpty
    }
}
