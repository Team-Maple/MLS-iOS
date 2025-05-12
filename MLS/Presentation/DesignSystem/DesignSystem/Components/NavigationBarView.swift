import UIKit

internal import SnapKit

public final class NavigationBarView: UIView {
    // MARK: - Types
    private struct Constant {
        static let imageSize: CGFloat = 44
        static let rightInset: CGFloat = 16
    }
    
    // MARK: - Properties
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        return view
    }()
    
    public let leftButton: UIButton = {
        let button = UIButton(type: .system)
        let image = DesignSystemAsset.image(named: "arrowLeft")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()

    public let rightButton: UIButton = {
        let button = UIButton(type: .system)
        let image = DesignSystemAsset.image(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .textColor
        return button
    }()
    
    public let textButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .neutral700
        button.titleLabel?.font = .body2
        return button
    }()
    
    private let spacingView: UIView = UIView()

    // MARK: - init
    public init(textButtonTitle: String? = nil) {
        super.init(frame: .zero)
        self.setupButtonTitle(textButtonTitle: textButtonTitle)
        self.addViews()
        self.setupContstraints()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension NavigationBarView {
    func setupButtonTitle(textButtonTitle: String?) {
        if let textButtonTitle = textButtonTitle, let lineHeight = UIFont.body2?.lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight * 1.2
            paragraphStyle.maximumLineHeight = lineHeight * 1.2
            paragraphStyle.alignment = .center
            
            let attributedString = NSAttributedString(
                string: textButtonTitle,
                attributes: [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor.neutral700,
                    .paragraphStyle: paragraphStyle
                ]
            )
            self.textButton.setAttributedTitle(attributedString, for: .normal)
        }
        
    }
    
    func addViews() {
        self.addSubview(contentStackView)
        contentStackView.addArrangedSubview(leftButton)
        contentStackView.addArrangedSubview(UIView())
        contentStackView.addArrangedSubview(textButton)
        contentStackView.addArrangedSubview(spacingView)
        contentStackView.addArrangedSubview(rightButton)
    }

    func setupContstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
        spacingView.snp.makeConstraints { make in
            make.width.equalTo(Constant.rightInset)
        }
    }

    func configureUI() { }
}
