import UIKit

internal import SnapKit

public final class CheckButton: UIButton {
    // MARK: - Types
    public enum ButtonType {
        case normal
        case list
        
        public var spacing: CGFloat {
            switch self {
            case .normal:
                return 16
            case .list:
                return 10
            }
        }
        
        public var font: UIFont? {
            switch self {
            case .normal:
                return .subTitleBold
            case .list:
                return .body2
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
    }
    
    private struct Constant {
        static let imageSize: CGFloat = 24
        static let cornerRadius: CGFloat = 6
        static let horizontalInset: CGFloat = 20
        static let labelSpacing: CGFloat = 4
    }

    // MARK: - Properties
    private let type: ButtonType
    
    public var title: String? {
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
        view.spacing = self?.type.spacing ?? 0
        return view
    }()
    
    private let labelTrailingView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let checkIconImageView: UIImageView = {
        let image = DesignSystemAsset.image(named: "checkicon")?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        return view
    }()
    
    private let buttonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        return label
    }()
    
    private let buttonSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        label.font = .body
        return label
    }()
    
    public let rightButton: UIButton = {
        let button = UIButton()
        let image = DesignSystemAsset.image(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()
    
    // MARK: - init
    public init(type: ButtonType, title: String?, subTitle: String?) {
        self.type = type
        self.title = title
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
private extension CheckButton {
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
            make.verticalEdges.equalToSuperview().inset(type.verticalInset)
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
        buttonTitleLabel.font = type.font
        buttonSubTitleLabel.isHidden = type.subtitleIsHidden
        
        if type == .normal {
            self.layer.cornerRadius = Constant.cornerRadius
            self.layer.borderColor = UIColor.neutral300.cgColor
            self.layer.borderWidth = 1
            self.clipsToBounds = true
            self.rightButton.isHidden = true
            self.backgroundColor = .neutral100
        } else {
            self.layer.cornerRadius = 0
            self.layer.borderWidth = 0
            self.rightButton.isHidden = false
        }
    }
    
    func updateTintColor() {
        checkIconImageView.tintColor = isSelected ? .primary700 : .neutral300
    }
    
    func updateText() {
        buttonTitleLabel.text = title
        buttonSubTitleLabel.text = subTitle
    }
}
