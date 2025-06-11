import UIKit

import DesignSystem

import SnapKit

final class ItemFilterBottomSheetView: UIView {

    private enum Constant {
        static let horizontalInset: CGFloat = 16
        static let buttonSpacing: CGFloat = 8
        static let buttonSuperViewSize = UIScreen.main.bounds.width - (Constant.horizontalInset * 2) - buttonSpacing
        static let buttonStackViewTopMargin: CGFloat = 12
        static let buttonStackViewBottomMargin: CGFloat = 16
        static let collectionViewTopOffset = 8
    }

    // MARK: - Properties
    let headerView: Header = {
        let view = Header(style: .filter)
        view.titleLabel.text = "필터"
        return view
    }()

    private let toolBarStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        return view
    }()

    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(
            top: Constant.buttonStackViewTopMargin,
            left: Constant.horizontalInset,
            bottom: Constant.buttonStackViewBottomMargin,
            right: Constant.horizontalInset
        )

        return view
    }()

    public let clearButton: CommonButton = {
        let button = CommonButton(style: .border, title: "초기화", disabledTitle: nil)
        return button
    }()

    public let applyButton: CommonButton = {
        let button = CommonButton(style: .normal, title: "n개의 아이템 보기", disabledTitle: nil)
        return button
    }()

    private let buttonStackViewDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral200
        return view
    }()

    public let categoryCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        return view
    }()

    public let contentCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.contentInset = .init(top: 40, left: 0, bottom: 0, right: 0)
        view.allowsMultipleSelection = true
        return view
    }()

    // MARK: - init
    init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension ItemFilterBottomSheetView {
    func addViews() {
        addSubview(headerView)
        addSubview(toolBarStackView)
        addSubview(categoryCollectionView)
        addSubview(contentCollectionView)
        toolBarStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(clearButton)
        buttonStackView.addArrangedSubview(applyButton)
        buttonStackView.addSubview(buttonStackViewDividerView)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        toolBarStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        clearButton.snp.makeConstraints { make in
            make.width.equalTo(Constant.buttonSuperViewSize * 0.3)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Constant.collectionViewTopOffset)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        contentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(toolBarStackView.snp.top)
        }
        buttonStackViewDividerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    func configureUI() { }
}
