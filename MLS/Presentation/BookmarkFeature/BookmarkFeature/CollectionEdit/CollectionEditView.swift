import UIKit

import DesignSystem

import SnapKit

final class CollectionEditView: UIView {
    // MARK: - Type
    enum Constant {
        static let imageViewSize: CGFloat = 44
        static let iconSize: CGFloat = 24
        static let horizontalMargin: CGFloat = 16
        static let topMargin: CGFloat = 12
        static let bottomMargin: CGFloat = 14
    }

    // MARK: - Components
    private lazy var imageView: UIView = {
        let view = UIView()

        view.addSubview(cancelButton)

        cancelButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }

        return view
    }()

    public let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX"), for: .normal)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .korFont(style: .semiBold, size: 16), text: "리스트 편집")
        return label
    }()

    public let listCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let divider = DividerView()

    public let addButtton = CommonButton(style: .normal, title: "컬렉션에 추가하기", disabledTitle: nil)

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
private extension CollectionEditView {
    func addViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(listCollectionView)
        addSubview(divider)
        addSubview(addButtton)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.size.equalTo(Constant.imageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageView)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(listCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        addButtton.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(Constant.topMargin)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalMargin)
            make.bottom.equalToSuperview().inset(Constant.bottomMargin)
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        listCollectionView.backgroundColor = .neutral100
    }
}
