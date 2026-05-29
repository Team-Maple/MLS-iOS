import MLSDesignSystem
import SnapKit
import UIKit

final class CollectionEditView: UIView {
    private enum Constant {
        static let imageViewSize: CGFloat = 44
        static let iconSize: CGFloat = 24
        static let horizontalMargin: CGFloat = 16
        static let topMargin: CGFloat = 12
        static let bottomMargin: CGFloat = 14
    }

    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }
        return view
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX"), for: .normal)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .korFont(style: .semiBold, size: 16), text: "리스트 편집")
        return label
    }()

    let listCollectionView: UICollectionView = {
        UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }()

    private let divider = DividerView()
    let addButtton = CommonButton(style: .normal, title: "컬렉션에 추가하기", disabledTitle: nil)

    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        backgroundColor = .whiteMLS
        listCollectionView.backgroundColor = .neutral100
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private extension CollectionEditView {
    func addViews() {
        addSubview(headerView)
        addSubview(titleLabel)
        addSubview(listCollectionView)
        addSubview(divider)
        addSubview(addButtton)
    }

    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.size.equalTo(Constant.imageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(headerView)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
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
}
