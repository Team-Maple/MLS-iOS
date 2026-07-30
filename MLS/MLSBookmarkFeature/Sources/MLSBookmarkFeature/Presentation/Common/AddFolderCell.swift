import MLSDesignSystem
import SnapKit
import UIKit

final class AddFolderCell: UICollectionViewCell {
    private enum Constant {
        static let iconInset: CGFloat = 8
        static let radius: CGFloat = 8
        static let margin: CGFloat = 16
        static let buttonSize: CGFloat = 40
    }

    private lazy var addIconView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.radius
        view.backgroundColor = .primary100

        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalTo(view).inset(Constant.iconInset)
        }
        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "addIcon").withRenderingMode(.alwaysTemplate)
        view.tintColor = .whiteMLS
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .b_m_r, text: "새로운 컬렉션 추가하기", alignment: .left)
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addIconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(divider)

        addIconView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(Constant.margin)
            make.size.equalTo(Constant.buttonSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(addIconView.snp.trailing).offset(Constant.margin)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.margin)
        }
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
