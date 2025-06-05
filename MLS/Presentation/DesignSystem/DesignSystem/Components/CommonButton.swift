import UIKit

internal import SnapKit

public final class CommonButton: UIButton {
    // MARK: - Type
    public enum CommonButtonStyle {
        case normal
        case text
        case border

        public var height: CGFloat {
            switch self {
            case .normal, .border:
                return 54
            case .text:
                return 44
            }
        }

        public var backgroundColor: UIColor {
            switch self {
            case .normal:
                .primary700
            case .text, .border:
                .clearMLS
            }
        }

        public var borderColor: CGColor {
            switch self {
            case .normal, .text:
                UIColor.clearMLS.cgColor
            case .border:
                UIColor.neutral300.cgColor
            }
        }

        public var textColor: UIColor {
            switch self {
            case .normal:
                .whiteMLS
            case .text:
                .neutral700
            case .border:
                .textColor
            }
        }
        
        public var font: UIFont? {
            switch self {
            case .normal:
                .subTitleBold
            case .text:
                .caption
            case .border:
                .body
            }
        }
    }

    private enum Constant {
        static let height: CGFloat = 54
        static let normalStyleCornerRadius: CGFloat = 8
        static let textLineHeight: CGFloat = 1.2
    }

    // MARK: - Properties
    private let style: CommonButtonStyle

    // MARK: - init
    public init(style: CommonButtonStyle, title: String?, disabledTitle: String?) {
        self.style = style
        super.init(frame: .zero)
        self.configureUI(title: title, disabledTitle: disabledTitle)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CommonButton {
    func configureUI(title: String?, disabledTitle: String?) {
        switch style {
        case .normal, .border:
            setAttributedTitle(.makeStyledString(font: style.font, text: title, color: style.textColor), for: .normal)
            setAttributedTitle(.makeStyledString(font: .subTitleBold, text: disabledTitle, color: .whiteMLS), for: .disabled)
            setBackgroundImage(UIImage.fromColor(style.backgroundColor), for: .normal)
            setBackgroundImage(UIImage.fromColor(.neutral300), for: .disabled)
            layer.cornerRadius = Constant.normalStyleCornerRadius
            layer.borderColor = self.style.borderColor
            clipsToBounds = true
            snp.makeConstraints { make in make.height.equalTo(style.height) }
        case .text:
            self.titleLabel?.font = style.font
            if let textButtonTitle = title,
               let lineHeight = style.font?.lineHeight
            {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.maximumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.alignment = .center

                let enabledAttributedString = NSAttributedString(
                    string: textButtonTitle,
                    attributes: [
                        .foregroundColor: style.textColor,
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: style.textColor,
                        .paragraphStyle: paragraphStyle
                    ]
                )
                self.setAttributedTitle(enabledAttributedString, for: .normal)

                if let disabledTitle = disabledTitle {
                    let disabledAttributedString = NSAttributedString(
                        string: disabledTitle,
                        attributes: [
                            .foregroundColor: style.textColor,
                            .underlineStyle: NSUnderlineStyle.single.rawValue,
                            .underlineColor: style.textColor,
                            .paragraphStyle: paragraphStyle
                        ]
                    )
                    self.setAttributedTitle(disabledAttributedString, for: .disabled)
                }
            }
        }
    }
}
