import MLSDesignSystem
import SnapKit
import UIKit

final class BookmarkModalView: UIView {
    private enum Constant {
        static let buttonTopMargin: CGFloat = 12
        static let buttonBottomMargin: CGFloat = 14
        static let horizontalMargin: CGFloat = 16
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h_xl_b, text: "컬렉션", alignment: .left)
        return label
    }()

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "largeX"), for: .normal)
        return button
    }()

    let folderCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()

    private let divider = DividerView()

    let addButtton = CommonButton(style: .normal, title: "", disabledTitle: "추가하기")

    init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private extension BookmarkModalView {
    func addViews() {
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(folderCollectionView)
        addSubview(divider)
        addSubview(addButtton)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
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
