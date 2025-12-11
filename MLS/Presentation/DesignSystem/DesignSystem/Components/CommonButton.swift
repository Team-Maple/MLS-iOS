import UIKit

import SnapKit

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

        public var borderColor: UIColor {
            switch self {
            case .normal, .text:
                UIColor.clearMLS
            case .border:
                UIColor.neutral300
            }
        }

        public var textColor: UIColor {
            switch self {
            case .normal:
                .whiteMLS
            case .text, .border:
                .textColor
            }
        }

        public var font: UIFont? {
            switch self {
            case .normal:
                .btn_m_b
            case .text:
                .btn_s_r
            case .border:
                .btn_m_r
            }
        }
    }

    private enum Constant {
        static let height: CGFloat = 54
        static let normalStyleCornerRadius: CGFloat = 8
        static let textLineHeight: CGFloat = 1.2
        static let buttonInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    }

    // MARK: - Properties
    private let style: CommonButtonStyle
    private var title: String?
    private var disabledTitle: String?

    override public var isEnabled: Bool {
        didSet {
            configureUI()
        }
    }

    // MARK: - init
    public init(style: CommonButtonStyle, title: String?, disabledTitle: String?) {
        self.style = style
        self.title = title
        self.disabledTitle = disabledTitle
        super.init(frame: .zero)
        configureUI()
    }

    public init() {
        self.style = .normal
        self.title = nil
        self.disabledTitle = nil
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CommonButton {
    func configureUI() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constant.buttonInsets

        switch style {
        case .normal, .border:
            config.background.backgroundColor = isEnabled ? style.backgroundColor : .neutral300
            config.background.cornerRadius = Constant.normalStyleCornerRadius
            let currentTitle = isEnabled ? title : disabledTitle
            config.attributedTitle = AttributedString(.makeStyledString(font: style.font, text: currentTitle, color: isEnabled ? style.textColor : .whiteMLS) ?? .init())
            config.baseForegroundColor = isEnabled ? style.textColor : .whiteMLS
            switch style {
            case .border:
                config.background.strokeColor = isEnabled ? style.borderColor : .neutral300
                config.background.strokeWidth = 1
            default:
                break
            }
            configuration = config
            snp.makeConstraints { make in
                make.height.equalTo(style.height)
            }
        case .text:
            config.background.backgroundColor = .clear
            let currentTitle = isEnabled ? title : disabledTitle
            if let textButtonTitle = currentTitle,
               let lineHeight = style.font?.lineHeight {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.maximumLineHeight = lineHeight * Constant.textLineHeight
                paragraphStyle.alignment = .center

                let enabledAttributedString = NSAttributedString(
                    string: textButtonTitle,
                    attributes: [
                        .foregroundColor: isEnabled ? style.textColor : .neutral700,
                        .underlineStyle: NSUnderlineStyle.single.rawValue,
                        .underlineColor: isEnabled ? style.textColor : .neutral700,
                        .paragraphStyle: paragraphStyle,
                        .font: style.font ?? UIFont()
                    ]
                )
                config.attributedTitle = AttributedString(enabledAttributedString)
            }
            configuration = config
        }

        configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var updatedConfig = button.configuration
            switch button.state {
            case .highlighted:
                switch style {
                case .normal:
                    updatedConfig?.background.backgroundColor = self.style.backgroundColor.withAlphaComponent(0.9)
                case .border:
                    updatedConfig?.background.backgroundColor = UIColor.neutral100
                default:
                    break
                }
            default:
                updatedConfig?.background.backgroundColor = self.isEnabled ? self.style.backgroundColor : .neutral300
            }
            button.configuration = updatedConfig
        }
    }
}

public extension CommonButton {
    func updateTitle(title: String, disabledTitle: String? = nil) {
        self.title = title
        if let disabledTitle = disabledTitle {
            self.disabledTitle = disabledTitle
        }
        configureUI()
    }

    func updateTitleColor(color: UIColor, for state: UIControl.State = .normal) {
        var config = configuration ?? UIButton.Configuration.plain()

        if var attributedTitle = config.attributedTitle {
            var container = AttributeContainer()
            container.foregroundColor = color
            attributedTitle.mergeAttributes(container, mergePolicy: .keepNew)
            config.attributedTitle = attributedTitle
        } else if let title = title(for: state) {
            config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.foregroundColor: color]))
        }

        configuration = config
    }
}
