import UIKit

import SnapKit

public final class TagChip: UIButton {
    // MARK: - Type
    public enum TagChipStyle {
        case normal
        case search

        var borderWidth: CGFloat {
            switch self {
            case .normal:
                return 0
            case .search:
                return 1
            }
        }

        var borderColor: CGColor {
            switch self {
            case .normal:
                return UIColor.clearMLS.cgColor
            case .search:
                return UIColor.neutral300.cgColor
            }
        }

        var fontColor: UIColor {
            switch self {
            case .normal:
                return .primary700
            case .search:
                return .textColor
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .normal:
                return .primary50
            case .search:
                return .clearMLS
            }
        }

        var radius: CGFloat {
            switch self {
            case .normal:
                return 16
            case .search:
                return 8
            }
        }

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .normal:
                return .init(top: 4, leading: 12, bottom: 4, trailing: 8)
            case .search:
                return .init(top: 4, leading: 10, bottom: 4, trailing: 10)
            }
        }
    }

    private enum Constant {
        static let height: CGFloat = 32
        static let imageSize: CGFloat = 24
    }

    // MARK: - Properties
    public var style: TagChipStyle {
        didSet {
            updateUI()
        }
    }

    public var text: String? {
        didSet {
            updateUI()
        }
    }

    public let mainTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    public let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()

    // MARK: - init
    public init(style: TagChipStyle, text: String?) {
        self.style = style
        self.text = text
        super.init(frame: .zero)

        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension TagChip {
    func setupConstraints() {
        addSubview(mainTitleLabel)
        addSubview(cancelButton)
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
        mainTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(style.contentInsets.leading)
            make.centerY.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalTo(mainTitleLabel.snp.trailing)
            make.verticalEdges.equalToSuperview().inset(style.contentInsets.top)
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(style.contentInsets.trailing)
        }
    }

    func configureUI() {
        let image = UIImage.smallX.withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
        cancelButton.tintColor = style.fontColor
    }

    func updateUI() {
        backgroundColor = style.backgroundColor
        mainTitleLabel.attributedText = .makeStyledString(font: .cp_s_r, text: text, color: style.fontColor)
        layer.borderColor = style.borderColor
        layer.borderWidth = style.borderWidth
        layer.cornerRadius = style.radius
        cancelButton.tintColor = style.fontColor
    }
}
