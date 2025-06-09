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
                return 1
            case .search:
                return 0
            }
        }
        
        var borderColor: CGColor {
            switch self {
            case .normal:
                return UIColor.neutral300.cgColor
            case .search:
                return UIColor.clearMLS.cgColor
            }
        }
        
        var fontColor: UIColor {
            switch self {
            case .normal:
                return .textColor
            case .search:
                return .primary700
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .normal:
                return .clearMLS
            case .search:
                return .primary50
            }
        }
        
        var radius: CGFloat {
            switch self {
            case .normal:
                return 8
            case .search:
                return 16
            }
        }
        
        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .normal:
                return .init(top: 6, leading: 10, bottom: 6, trailing: 10)
            case .search:
                return .init(top: 6, leading: 12, bottom: 6, trailing: 12)
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
    
    public var text: String {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - init
    public init(style: TagChipStyle, text: String) {
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
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
    }
    
    func configureUI() {
        var config = UIButton.Configuration.plain()
        let resizedImage = UIImage.smallX.resizeImage(to: CGSize(width: Constant.imageSize, height: Constant.imageSize))
        config.image = resizedImage?.withRenderingMode(.alwaysTemplate).withTintColor(style.fontColor)
        config.imagePlacement = .trailing
        configuration = config
    }
        
    func updateUI() {
        backgroundColor = style.backgroundColor
        var config = configuration ?? .plain()
        config.contentInsets = style.contentInsets
        config.baseForegroundColor = style.fontColor
        config.attributedTitle = AttributedString(.makeStyledString(font: isSelected ? .captionBold : .caption, text: text, color: style.fontColor) ?? .init())
        layer.borderColor = style.borderColor
        layer.borderWidth = style.borderWidth
        layer.cornerRadius = style.radius
        configuration = config
    }
}
