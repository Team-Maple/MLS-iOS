import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class AddFolderCell: UICollectionViewCell {
    private struct Constant {
        static let iconInset: CGFloat = 8
        static let radius: CGFloat = 8
        static let margin: CGFloat = 16
        static let buttonSize: CGFloat = 40
    }

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constant.radius
        button.backgroundColor = .primary100

        button.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalTo(button).inset(Constant.iconInset)
        }
        return button
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "addIcon")?.withRenderingMode(.alwaysTemplate)
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

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension AddFolderCell {
    func addViews() {
        contentView.addSubview(addButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(divider)
    }

    func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(Constant.margin)
            make.size.equalTo(Constant.buttonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(addButton.snp.trailing).offset(Constant.margin)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.margin)
        }

        divider.snp.makeConstraints { make in
             make.height.equalTo(1)
             make.leading.trailing.bottom.equalToSuperview()
         }
    }
}
