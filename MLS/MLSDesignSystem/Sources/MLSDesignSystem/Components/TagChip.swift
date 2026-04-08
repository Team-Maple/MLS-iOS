import UIKit

import SnapKit

public final class TagChip: UIButton {
    // MARK: - Type
    public enum TagChipStyle {
        case normal
        case search
        case text

        var borderWidth: CGFloat {
            switch self {
            case .normal, .text: return 0
            case .search: return 1
            }
        }

        var borderColor: CGColor {
            switch self {
            case .normal, .text: return UIColor.clearMLS.cgColor
            case .search: return UIColor.neutral300.cgColor
            }
        }

        var fontColor: UIColor {
            switch self {
            case .normal, .text: return .primary700
            case .search: return .textColor
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .normal, .text: return .primary50
            case .search: return .clearMLS
            }
        }

        var radius: CGFloat {
            switch self {
            case .normal: return 16
            case .text: return 12
            case .search: return 8
            }
        }

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .normal:
                return .init(top: 4, leading: 12, bottom: 4, trailing: 8)
            case .text:
                return .init(top: 4, leading: 12, bottom: 4, trailing: 12)
            case .search:
                return .init(top: 4, leading: 10, bottom: 4, trailing: 10)
            }
        }

        var font: UIFont? {
            switch self {
            case .text: return .cp_s_sb
            case .normal, .search: return .cp_s_r
            }
        }

        var isHiddenButton: Bool {
            switch self {
            case .normal, .search: return false
            case .text: return true
            }
        }
    }

    private enum Constant {
        static let height: CGFloat = 32
        static let imageSize: CGFloat = 24
    }

    // MARK: - Properties
    public var style: TagChipStyle {
        didSet { updateUI() }
    }

    public var text: String? {
        didSet { updateUI() }
    }

    public let mainTitleLabel = UILabel()

    public let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()

    private var cancelButtonWidthConstraint: Constraint?

    // MARK: - init
    public init(style: TagChipStyle, text: String?) {
        self.style = style
        self.text = text
        super.init(frame: .zero)

        setupLayout()
        configureUI()
        updateUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension TagChip {
    func setupLayout() {
        addSubview(mainTitleLabel)
        addSubview(cancelButton)

        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        mainTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(style.contentInsets.leading)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(cancelButton.snp.leading).offset(-4)
        }

        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(style.contentInsets.trailing)
            make.centerY.equalToSuperview()
            cancelButtonWidthConstraint = make.width.equalTo(Constant.imageSize).constraint
            make.height.equalTo(Constant.imageSize)
        }
    }

    func configureUI() {
        let image = DesignSystemAsset.image(named: "smallX")
            .withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
    }

    func updateUI() {
        backgroundColor = style.backgroundColor

        mainTitleLabel.attributedText = .makeStyledString(
            font: style.font,
            text: text,
            color: style.fontColor
        )

        layer.borderColor = style.borderColor
        layer.borderWidth = style.borderWidth
        layer.cornerRadius = style.radius

        cancelButton.tintColor = style.fontColor

        let hidden = style.isHiddenButton
        cancelButton.isHidden = hidden
        cancelButtonWidthConstraint?.update(offset: hidden ? 0 : Constant.imageSize)
    }
}
