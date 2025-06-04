import UIKit

internal import SnapKit

public final class CommonButton: UIButton {
    // MARK: - Type
    public enum CommonButtonStyle {
        case normal
        case text

        public var height: CGFloat {
            switch self {
            case .normal:
                return 54
            case .text:
                return 44
            }
        }
    }
    private struct Constant {
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

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CommonButton {
    func configureUI(title: String?, disabledTitle: String?) {

        switch style {
        case .normal:
            self.setAttributedTitle(.makeStyledString(font: .subTitleBold, text: title, color: .white), for: .normal)
            self.setAttributedTitle(.makeStyledString(font: .subTitleBold, text: disabledTitle, color: .white), for: .disabled)
            self.setBackgroundImage(UIImage.fromColor(.primary700), for: .normal)
            self.setBackgroundImage(UIImage.fromColor(.neutral300), for: .disabled)
            self.layer.cornerRadius = Constant.normalStyleCornerRadius
            self.clipsToBounds = true
            self.snp.makeConstraints { make in make.height.equalTo(style.height) }
        case .text:
            self.titleLabel?.font = .caption
            if let textButtonTitle = title,
               let lineHeight = UIFont.caption?.lineHeight {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.maximumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.alignment = .center

                let enabledAttributedString = NSAttributedString(
                    string: textButtonTitle,
                    attributes: [
                        .foregroundColor: UIColor.neutral700,
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: UIColor.neutral700,
                        .paragraphStyle: paragraphStyle
                    ]
                )
                self.setAttributedTitle(enabledAttributedString, for: .normal)

                if let disabledTitle = disabledTitle {
                    let disabledAttributedString = NSAttributedString(
                        string: disabledTitle,
                        attributes: [
                            .foregroundColor: UIColor.neutral700,
                            .underlineStyle: NSUnderlineStyle.single.rawValue,
                            .underlineColor: UIColor.neutral700,
                            .paragraphStyle: paragraphStyle
                        ]
                    )
                    self.setAttributedTitle(disabledAttributedString, for: .disabled)
                }
            }
        }
    }
}
