import UIKit

internal import SnapKit

public final class CheckBoxButton: UIButton {
    // MARK: - Types
    public enum CheckBoxButtonStyle {
        case normal
        case list
        
        public var font: UIFont? {
            switch self {
            case .normal:
                return .subTitleBold
            case .list:
                return .caption
            }
        }
        
        public var verticalInset: CGFloat {
            switch self {
            case .normal:
                return 16
            case .list:
                return 10
            }
        }
        
        public var subtitleIsHidden: Bool {
            switch self {
            case .normal:
                return false
            case .list:
                return true
            }
        }
        
        public var rightButtonIsHidden: Bool {
            switch self {
            case .normal:
                return true
            case .list:
                return false
            }
        }
        
        public var cornerRadius: CGFloat {
            switch self {
            case .normal:
                return 6
            case .list:
                return 0
            }
        }
        
        public var borderWidth: CGFloat {
            switch self {
            case .normal:
                return 1
            case .list:
                return 0
            }
        }
    }
    
    private struct Constant {
        static let imageSize: CGFloat = 24
        static let horizontalInset: CGFloat = 20
        static let labelSpacing: CGFloat = 4
        static let spacing: CGFloat = 8
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
        self.setupContstraints()
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
        
        contentStackView.addArrangedSubview(checkIconImageView)
        contentStackView.addArrangedSubview(labelTrailingView)
        contentStackView.addArrangedSubview(UIView())
        contentStackView.addArrangedSubview(rightButton)
    }

    func setupContstraints() {
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
        
        self.layer.cornerRadius = style.cornerRadius
        self.layer.borderWidth = style.borderWidth
        self.rightButton.isHidden = style.rightButtonIsHidden
        
        if style == .normal {
            self.layer.borderColor = UIColor.neutral300.cgColor
            self.clipsToBounds = true
            self.backgroundColor = .neutral100
        }
    }
    
    func updateTintColor() {
        checkIconImageView.tintColor = isSelected ? .primary700 : .neutral300
    }
    
    func updateText() {
        buttonTitleLabel.attributedText = .makeStyledString(font: style.font, text: mainTitle)
        buttonSubTitleLabel.attributedText = .makeStyledString(font: .body, text: subTitle)
    }
}
