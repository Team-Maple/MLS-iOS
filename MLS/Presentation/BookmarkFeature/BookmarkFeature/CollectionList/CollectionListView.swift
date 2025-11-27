import UIKit

import DesignSystem
import DomainInterface

import SnapKit

final class CollectionListView: UIView {
    // MARK: - Type
    enum Constant {
        static let stackViewSpacing: CGFloat = 12
        static let topMargin: CGFloat = 12
        static let filterHeight: CGFloat = 32
        static let horizontalMargin: CGFloat = 16
        static let nonFilterTopMargin: CGFloat = 20
    }

    // MARK: - Components
    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private lazy var filterStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sortButton])
        view.axis = .horizontal
        view.spacing = Constant.stackViewSpacing
        view.distribution = .fillProportionally
        return view
    }()

    public lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.makeStyledString(font: .b_s_r, text: "최신 순", color: .textColor), for: .normal)
        button.setImage(DesignSystemAsset.image(named: "lineArrowDown")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    public let emptyView: CollectionListEmptyView = {
        let view = CollectionListEmptyView()
        view.isHidden = true
        return view
    }()

    // MARK: - Init
    init() {
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
private extension CollectionListView {
    func addViews() {
        addSubview(filterStackView)
        addSubview(listCollectionView)
        addSubview(emptyView)
    }

    func setupConstraints() {
        filterStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.topMargin)
            make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
        }

        sortButton.snp.makeConstraints { make in
            make.height.equalTo(Constant.filterHeight)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
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

extension CollectionListView {
    func updateView(isEmptyData: Bool) {
        emptyView.isHidden = !isEmptyData
        filterStackView.isHidden = isEmptyData
        listCollectionView.isHidden = isEmptyData

        if isEmptyData {
            listCollectionView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(Constant.nonFilterTopMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        } else {
            filterStackView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(Constant.topMargin)
                make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
            }

            listCollectionView.snp.remakeConstraints { make in
                make.top.equalTo(filterStackView.snp.bottom).offset(Constant.topMargin)
                make.horizontalEdges.bottom.equalToSuperview()
            }
        }
    }

    func selectFilter(selectedType: SortType) {
        sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: selectedType.rawValue, color: .primary700), for: .normal)
        sortButton.tintColor = .primary700
    }

    func selectSort(selectedType: SortType) {
        sortButton.setAttributedTitle(.makeStyledString(font: .b_s_r, text: selectedType.rawValue, color: .primary700), for: .normal)
        sortButton.tintColor = .primary700
    }
}
