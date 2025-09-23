import UIKit

import SnapKit

public final class Badge: UIView {
    // MARK: - Type
    public enum BadgeStyle {
        case element(String)
        case preQuest
        case currentQuest
        case nextQuest

        var font: UIFont? {
            switch self {
            case .element:
                return .cp_s_sb
            case .currentQuest:
                return .cp_xs_sb
            default:
                return .cp_xs_r
            }
        }

        var fontColor: UIColor {
            switch self {
            case .element, .currentQuest:
                return .primary700
            default:
                return .neutral600
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .element, .currentQuest:
                return .primary25
            default:
                return .neutral100
            }
        }

        var text: String {
            switch self {
            case .element(let text):
                return text
            case .preQuest:
                return "이전 퀘스트"
            case .currentQuest:
                return "현재 퀘스트"
            case .nextQuest:
                return "다음 퀘스트"
            }
        }
    }

    private enum Constant {
        static let radius: CGFloat = 4
        static let contentInsets: CGFloat = 6
    }

    // MARK: - Components
    private let textLabel = UILabel()

    // MARK: - init
    public init(style: BadgeStyle) {
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI(style: style)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension Badge {
    func addViews() {
        addSubview(textLabel)
    }

    func setupConstraints() {
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constant.contentInsets)
        }
    }

    func configureUI(style: BadgeStyle) {
        layer.cornerRadius = Constant.radius
        backgroundColor = style.backgroundColor
        textLabel.attributedText = .makeStyledString(font: style.font, text: style.text, color: style.fontColor, lineHeight: 1)
    }
}

public extension Badge {
    func update(style: BadgeStyle) {
        configureUI(style: style)
    }
}
