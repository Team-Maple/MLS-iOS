import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class DictionaryListView: UIView {
    // MARK: - Type
    enum Constant {
        static let filterInset: CGFloat = 6
        static let iconSize: CGFloat = 24
        static let stackViewSpacing: CGFloat = 12
        static let topMargin: CGFloat = 12
        static let nonFilterTopMargin: CGFloat = 20
        static let cellSpacing: CGFloat = 10
        static let cellWidth: CGFloat = 343
        static let cellHeight: CGFloat = 104
        static let horizontalMargin: CGFloat = 16
        static let bottomInset: CGFloat = 64
        static let filterHeight: CGFloat = 32
    }

    // MARK: - Components
    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private lazy var filterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [UIView(), sortButton, filterButton])
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        return view
    }()

    public lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "가나다 순"), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "lineArrowDown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .neutral900
        button.setTitleColor(.neutral900, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    public lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "필터"), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .neutral900
        button.setTitleColor(.neutral900, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    public let emptyView = DictionaryListEmptyView()

    // MARK: - Init
    init(isFilterHidden: Bool) {
        super.init(frame: .zero)
        addViews(isFilterHidden: isFilterHidden)
        setupConstraints(isFilterHidden: isFilterHidden)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryListView {
    func addViews(isFilterHidden: Bool) {
        if isFilterHidden {
            addSubview(listCollectionView)
            addSubview(emptyView)
        } else {
            addSubview(filterStackView)
            addSubview(listCollectionView)
            addSubview(emptyView)
        }
    }

    func setupConstraints(isFilterHidden: Bool) {
        if isFilterHidden {
            listCollectionView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(Constant.nonFilterTopMargin)
                make.horizontalEdges.bottom.equalToSuperview()
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
            
            sortButton.snp.makeConstraints { make in
                make.height.equalTo(Constant.filterHeight)
            }
            
            filterButton.snp.makeConstraints { make in
                make.height.equalTo(Constant.filterHeight)
            }

            listCollectionView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }

            emptyView.snp.makeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom)
                make.trailing.leading.bottom.equalToSuperview()
            }
        }
    }

    func configureUI() {
        backgroundColor = .neutral100
        listCollectionView.backgroundColor = .neutral100
    }
}

extension DictionaryListView {
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
}
