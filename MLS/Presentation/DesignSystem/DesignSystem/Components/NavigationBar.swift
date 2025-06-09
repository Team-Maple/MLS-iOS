import UIKit

import SnapKit

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

    public let textButton: UIButton = UIButton(type: .system)

    private let leftSpacingView: UIView = UIView()
    private let rightSpacingView: UIView = UIView()

    // MARK: - init
    public init(textButtonTitle: String? = nil) {
        super.init(frame: .zero)
        self.addViews(textButtonTitle: textButtonTitle)
        self.setupConstraints()
        self.configureUI(textButtonTitle: textButtonTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension NavigationBar {
    func addViews(textButtonTitle: String? = nil) {
        self.addSubview(contentStackView)
        contentStackView.addArrangedSubview(leftButton)
        contentStackView.addArrangedSubview(leftSpacingView)
        if textButtonTitle != nil { contentStackView.addArrangedSubview(textButton) }
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

    func configureUI(textButtonTitle: String?) {
        if let textButtonTitle, let lineHeight = UIFont.caption?.lineHeight, let font = UIFont.body {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.maximumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.alignment = .center

            let attributedString = NSAttributedString(
                string: textButtonTitle,
                attributes: [
                    .font: font,
                    .foregroundColor: UIColor.neutral700,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor.neutral700,
                    .paragraphStyle: paragraphStyle
                ]
            )
            self.textButton.setAttributedTitle(attributedString, for: .normal)
        }
    }
}
