import UIKit

import DesignSystem

import RxSwift
import SnapKit

public class FolderCell: UICollectionViewCell {
    private enum Constant {
        static let iconInset: CGFloat = 8
        static let radius: CGFloat = 8
        static let margin: CGFloat = 16
        static let iconSize: CGFloat = 24
        static let buttonSize: CGFloat = 40
    }

    private lazy var imageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constant.radius
        view.backgroundColor = .neutral200

        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.center.equalTo(view).inset(Constant.iconInset)
        }
        return view
    }()

    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = DesignSystemAsset.image(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .neutral300
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    public let checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(DesignSystemAsset.image(named: "checkSquareFill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .neutral300
        return button
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral100
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupConstraints()
        bindButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension FolderCell {
    func addViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(divider)
    }

    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(Constant.margin)
            make.size.equalTo(Constant.buttonSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(Constant.margin)
            make.centerY.equalToSuperview()
        }

        checkBoxButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(Constant.margin)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.margin)
            make.size.equalTo(Constant.iconSize)
        }

        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func bindButton() {
        checkBoxButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.checkBoxButton.isSelected.toggle()
            self.checkBoxButton.tintColor = self.checkBoxButton.isSelected ? .primary700 : .neutral300
        }), for: .touchUpInside)
    }
}

public extension FolderCell {
    func inject(title: String?) {
        titleLabel.attributedText = .makeStyledString(font: .body, text: title, alignment: .left)
    }

    func toggleSelected() {
        checkBoxButton.isSelected.toggle()
        checkBoxButton.tintColor = checkBoxButton.isSelected ? .primary700 : .neutral300
    }
}
