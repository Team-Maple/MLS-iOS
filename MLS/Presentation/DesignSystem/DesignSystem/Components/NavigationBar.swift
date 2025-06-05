import UIKit

internal import SnapKit

public final class NavigationBar: UIView {
    // MARK: - Types
    private struct Constant {
        static let imageSize: CGFloat = 44
        static let rightInset: CGFloat = 16
        static let lineHeight: CGFloat = 1.17
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

    public let underlineTextButton: UIButton = UIButton(type: .system)
    public let boldTextButton: UIButton = UIButton()

    private let leftSpacingView: UIView = UIView()
    private let rightSpacingView: UIView = UIView()

    // MARK: - init
    public init(underlineTextButtonTitle: String? = nil, boldTextButtonTitle: String? = nil) {
        super.init(frame: .zero)
        self.addViews(underlineTextButtonTitle: underlineTextButtonTitle, boldTextButtonTitle: boldTextButtonTitle)
        self.setupConstraints()
        self.configureUI(underlineTextButtonTitle: underlineTextButtonTitle, boldTextButtonTitle: boldTextButtonTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension NavigationBar {
    func addViews(underlineTextButtonTitle: String? = nil, boldTextButtonTitle: String? = nil) {
        self.addSubview(contentStackView)
        contentStackView.addArrangedSubview(leftButton)
        contentStackView.addArrangedSubview(leftSpacingView)
        if underlineTextButtonTitle != nil { contentStackView.addArrangedSubview(underlineTextButton) }
        if boldTextButtonTitle != nil { contentStackView.addArrangedSubview(boldTextButton) }
        contentStackView.addArrangedSubview(rightSpacingView)
        contentStackView.addArrangedSubview(rightButton)
    }

    func setupConstraints() {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
        rightSpacingView.snp.makeConstraints { make in
            make.width.equalTo(Constant.rightInset)
        }
    }

    func configureUI(underlineTextButtonTitle: String?, boldTextButtonTitle: String?) {
        if let underlineTextButtonTitle, let lineHeight = UIFont.caption?.lineHeight, let font = UIFont.body {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.maximumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.alignment = .center

            let attributedString = NSAttributedString(
                string: underlineTextButtonTitle,
                attributes: [
                    .font: font,
                    .foregroundColor: UIColor.neutral700,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor.neutral700,
                    .paragraphStyle: paragraphStyle
                ]
            )
            self.underlineTextButton.setAttributedTitle(attributedString, for: .normal)
        }
        
        if let boldTextButtonTitle {
            boldTextButton.setAttributedTitle(.makeStyledString(font: .subTitleBold, text: boldTextButtonTitle), for: .normal)
        }
    }
}
