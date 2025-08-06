import UIKit

import SnapKit

public final class TextButton: UIButton {
    // MARK: - Type

    private enum Constant {
        static let height: CGFloat = 32
        static let iconSize: CGFloat = 16
        static let horizontalInset: CGFloat = 12
        static let spacing: CGFloat = 4
        static let radius: CGFloat = 16
    }

    // MARK: - Properties
    public let iconView: UIImageView = {
        let view = UIImageView()
        view.image = .edit.withRenderingMode(.alwaysTemplate)
        view.tintColor = .neutral700
        return view
    }()

    public let textLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .btn_s_r, text: "편집", color: .neutral700)
        return label
    }()

    // MARK: - init
    public init() {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension TextButton {
    func addViews() {
        addSubview(iconView)
        addSubview(textLabel)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constant.horizontalInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }

        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(Constant.spacing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constant.horizontalInset)
        }
    }

    func configureUI() {
        backgroundColor = .whiteMLS
        layer.cornerRadius = Constant.radius
        layer.borderWidth = 1
        layer.borderColor = UIColor.neutral300.cgColor
    }
}
