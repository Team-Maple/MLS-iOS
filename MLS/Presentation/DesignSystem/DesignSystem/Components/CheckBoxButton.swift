import UIKit

import SnapKit

public final class CheckBoxButton: UIButton {
    // MARK: - Types
    public enum CheckBoxButtonStyle {
        case normal
        case listSmall
        case listMedium
        case listLarge

        public var font: UIFont? {
            switch self {
            case .normal:
                return .subTitleBold
            case .listSmall, .listMedium:
                return .caption
            case .listLarge:
                return .body
            }
        }

        public var verticalInset: CGFloat {
            switch self {
            case .normal, .listLarge:
                return 16
            case .listSmall:
                return 4
            case .listMedium:
                return 10
            }
        }

        public var subtitleIsHidden: Bool {
            switch self {
            case .normal:
                return false
            default:
                return true
            }
        }

        public var rightButtonIsHidden: Bool {
            switch self {
            case .listMedium:
                return false
            default:
                return true
            }
        }

        public var backgroundColor: UIColor {
            switch self {
            case .normal:
                return .neutral100
            default:
                return .clearMLS
            }
        }

        public var textColor: UIColor {
            switch self {
            case .listSmall:
                return .neutral700
            default:
                return .textColor
            }
        }

        public var selecteTextColor: UIColor {
            switch self {
            case .listSmall:
                return .primary700
            default:
                return .textColor
            }
        }

        public var height: CGFloat? {
            switch self {
            case .normal:
                return 56
            case .listSmall:
                return 32
            case .listMedium:
                return 44
            case .listLarge:
                return nil
            }
        }
    }

    private struct Constant {
        static let imageSize: CGFloat = 24
        static let horizontalInset: CGFloat = 20
        static let labelSpacing: CGFloat = 4
        static let spacing: CGFloat = 8
        static let radius: CGFloat = 6
    }

    // MARK: - Properties
    private let style: CheckBoxButtonStyle

    public var mainTitle: String? {
        didSet {
            updateText()
        }
    }

    public var subTitle: String? {
        didSet {
            updateText()
        }
    }

    public override var isSelected: Bool {
        didSet {
            updateTintColor()
        }
    }

    private lazy var contentStackView: UIStackView = { [weak self] in
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.spacing = Constant.spacing
        return view
    }()

    private let labelTrailingView: UIView = UIView()

    private let checkIconImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "checkicon")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        return view
    }()

    private let buttonTitleLabel: UILabel = UILabel()

    private let buttonSubTitleLabel: UILabel = UILabel()

    public let rightButton: UIButton = {
        let button = UIButton()
        let image = DesignSystemAsset.image(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()

    // MARK: - init
    public init(style: CheckBoxButtonStyle, mainTitle: String?, subTitle: String?) {
        self.style = style
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        super.init(frame: .zero)
        self.addViews()
        self.setupConstraints()
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension CheckBoxButton {
    func addViews() {
        self.addSubview(contentStackView)
        labelTrailingView.addSubview(buttonTitleLabel)
        labelTrailingView.addSubview(buttonSubTitleLabel)

        if style == .listLarge {
            contentStackView.addArrangedSubview(labelTrailingView)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(checkIconImageView)
        } else {
            contentStackView.addArrangedSubview(checkIconImageView)
            contentStackView.addArrangedSubview(labelTrailingView)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(rightButton)
        }
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            if let height = style.height {
                make.height.equalTo(height)
            }
        }

        contentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.verticalEdges.equalToSuperview().inset(style.verticalInset)
        }

        checkIconImageView.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }

        buttonTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        buttonSubTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(buttonTitleLabel.snp.trailing).offset(Constant.labelSpacing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        rightButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
    }

    func configureUI() {
        updateTintColor()
        updateText()

        buttonTitleLabel.font = style.font
        buttonSubTitleLabel.isHidden = style.subtitleIsHidden
        backgroundColor = style.backgroundColor
        layer.cornerRadius = Constant.radius
        rightButton.isHidden = style.rightButtonIsHidden
    }

    func updateTintColor() {
        checkIconImageView.tintColor = isSelected ? .primary700 : .neutral300
        buttonTitleLabel.attributedText = .makeStyledString(font: style.font, text: mainTitle, color: isSelected ? style.selecteTextColor : style.textColor)
    }

    func updateText() {
        buttonTitleLabel.attributedText = .makeStyledString(font: style.font, text: mainTitle, color: style.textColor)
        buttonSubTitleLabel.attributedText = .makeStyledString(font: .body, text: subTitle)
    }
}
