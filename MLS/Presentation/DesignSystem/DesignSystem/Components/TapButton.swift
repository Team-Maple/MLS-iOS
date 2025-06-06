import UIKit

internal import SnapKit

public final class TapButton: UIButton {
    // MARK: - Type
    private enum Constant {
        static let height: CGFloat = 34
        static let borderWidth: CGFloat = 1
        static let radius: CGFloat = 17
        static let contentInsets: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
    }
    
    // MARK: - Properties
    override public var isSelected: Bool {
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
    public init(text: String) {
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
private extension TapButton {
    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }
    }
    
    func configureUI() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = Constant.contentInsets
        configuration = config
    }
        
    func updateUI() {
        var config = configuration ?? .plain()
        config.contentInsets = Constant.contentInsets
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = isSelected ? .primary700 : .neutral700
        config.attributedTitle = AttributedString(.makeStyledString(font: isSelected ? .captionBold : .caption, text: text, color: isSelected ? .primary700 : .neutral700) ?? .init())
        layer.borderColor = isSelected ? UIColor.primary700.cgColor : UIColor.neutral700.cgColor
            
        layer.borderWidth = Constant.borderWidth
        layer.cornerRadius = Constant.radius
        configuration = config
    }
}
