import UIKit

import DesignSystem

import SnapKit

final class BookmarkModalView: UIView {
    // MARK: - Type
    enum Constant {
        static let buttonTopMargin: CGFloat = 12
        static let buttonBottomMargin: CGFloat = 14
        static let horizontalMargin: CGFloat = 16
        static let backButtonSize: CGFloat = 24
        static let titleTopMargin: CGFloat = 20
        static let titleBottomMargin: CGFloat = 12
    }

    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "컬렉션", alignment: .left)
        return label
    }()

    public let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX"), for: .normal)
        return button
    }()

    public let folderCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let divider = DividerView()

    public let addButtton = CommonButton(style: .normal, title: "", disabledTitle: "추가하기")

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension BookmarkModalView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(folderCollectionView)
        addSubview(addButtton)
        addSubview(divider)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(Constant.horizontalMargin)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(Constant.horizontalMargin)
        }

        folderCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.titleBottomMargin)
            make.horizontalEdges.equalToSuperview()
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(folderCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        addButtton.snp.makeConstraints { make in
            make.top.equalTo(folderCollectionView.snp.bottom).offset(Constant.buttonTopMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constant.buttonBottomMargin)
        }
    }
}

// MARK: - Methods
extension BookmarkModalView {
    func setButtonTitle(count: Int) {
        if count == 0 {
            addButtton.isEnabled = false
        } else {
            addButtton.isEnabled = true
            addButtton.updateTitle(title: "\(count)개의 컬렉션 추가하기")
        }
    }
}
