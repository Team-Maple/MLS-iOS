import UIKit

import SnapKit

public final class SnackBar: UIView {
    private enum Constant {
        static let imageSize: CGFloat = 32
        static let imageInset: CGFloat = 5
        static let horizontalInset: CGFloat = 16
        static let width: CGFloat = 343
        static let height: CGFloat = 48
        static let spacing: CGFloat = 8
        static let radius: CGFloat = 8
    }

    // MARK: - ProPerties
    private let type: SnackBarType

    // MARK: - Components
    public let imageView: ItemImageView
    private let label = UILabel()
    private let button = UIButton()

    // MARK: - init
    public init(type: SnackBarType, image: UIImage?, imageBackgroundColor: UIColor, text: String, buttonText: String, buttonAction: (() -> Void)?) {
        self.type = type
        imageView = ItemImageView(image: image, cornerRadius: 3.432, inset: 5, backgroundColor: imageBackgroundColor)
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI(text: text, buttonText: buttonText, buttonAction: buttonAction)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension SnackBar {
    func addViews() {
        addSubview(imageView)
        addSubview(label)
        addSubview(button)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.width.equalTo(Constant.width)
            make.height.equalTo(Constant.height)
        }

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constant.horizontalInset)
            make.size.equalTo(Constant.imageSize)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(Constant.spacing)
        }

        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(label.snp.trailing)
            make.trailing.equalToSuperview().inset(Constant.horizontalInset)
        }

        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configureUI(text: String, buttonText: String, buttonAction: (() -> Void)?) {
        layer.cornerRadius = Constant.radius
        clipsToBounds = true

        label.adjustsFontSizeToFitWidth = true
        label.attributedText = .makeStyledString(font: .b_s_r, text: text, color: .whiteMLS, alignment: .left)

        let attributedTitle = NSAttributedString(
            string: buttonText,
            attributes: [
                .font: UIFont.btn_xs_r ?? UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.whiteMLS,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor.whiteMLS
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .clear
        button.addAction(UIAction { _ in
            buttonAction?()
        }, for: .touchUpInside)

        switch type {
        case .normal:
            backgroundColor = .neutral900
        case .delete:
            backgroundColor = .error900
        }
    }
}

public extension SnackBar {
    enum SnackBarType {
        case normal
        case delete
    }
}
