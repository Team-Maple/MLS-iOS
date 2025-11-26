import UIKit

import SnapKit

public final class NavigationBar: UIView {
    // MARK: - Types
    public enum NavigationType {
        case withUnderLine(String)
        case arrowRightLeft
        case arrowLeft
        case withString(String)
        case collection(String)
    }

    private enum Constant {
        static let spacing: CGFloat = 8
        static let imageSize: CGFloat = 44
        static let rightInset: CGFloat = 16
        static let lineHeight: CGFloat = 1.17
    }

    // MARK: - Properties
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = Constant.spacing
        return view
    }()

    public let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.arrowBack.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        return button
    }()

    public let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.arrowForward.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .textColor
        return button
    }()

    public let underlineTextButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return button
    }()

    public let boldTextButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return button
    }()

    private let collectionTitleLabel = UILabel()
    public let editButton: UIButton = {
        let button = UIButton()
        button.setImage(.edit, for: .normal)
        return button
    }()

    public let addButton: UIButton = {
        let button = UIButton()
        button.setImage(.addIcon, for: .normal)
        return button
    }()

    // MARK: - init
    public init(type: NavigationType) {
        super.init(frame: .zero)
        addViews(type: type)
        setupConstraints(type: type)
        configureUI(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension NavigationBar {
    func addViews(type: NavigationType) {
        addSubview(contentStackView)

        switch type {
        case .withUnderLine:
            contentStackView.addArrangedSubview(leftButton)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(underlineTextButton)
        case .arrowRightLeft:
            contentStackView.addArrangedSubview(leftButton)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(rightButton)
        case .arrowLeft:
            contentStackView.addArrangedSubview(leftButton)
            contentStackView.addArrangedSubview(UIView())
        case .withString:
            contentStackView.addArrangedSubview(leftButton)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(boldTextButton)
        case .collection:
            contentStackView.addArrangedSubview(leftButton)
            contentStackView.addArrangedSubview(collectionTitleLabel)
            contentStackView.addArrangedSubview(UIView())
            contentStackView.addArrangedSubview(editButton)
            contentStackView.addArrangedSubview(addButton)
        }
    }

    func setupConstraints(type: NavigationType) {
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.imageSize)
        }
        switch type {
        case .withUnderLine, .arrowRightLeft:
            rightButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.imageSize)
            }
        case .withString:
            boldTextButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
            }
        case .collection:
            editButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.imageSize)
            }
            addButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.imageSize)
            }
        default:
            break
        }
    }

    func configureUI(type: NavigationType) {
        switch type {
        case .withUnderLine(let title):
            guard let lineHeight = UIFont.b_s_r?.lineHeight,
                  let font = UIFont.b_m_r else { return }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.maximumLineHeight = lineHeight * Constant.lineHeight
            paragraphStyle.alignment = .center

            let attributedString = NSAttributedString(
                string: title,
                attributes: [
                    .font: font,
                    .foregroundColor: UIColor.neutral700,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .underlineColor: UIColor.neutral700,
                    .paragraphStyle: paragraphStyle
                ]
            )
            underlineTextButton.setAttributedTitle(attributedString, for: .normal)
        case .withString(let title):
            boldTextButton.setAttributedTitle(
                .makeStyledString(font: .btn_m_b, text: title),
                for: .normal
            )
        case .collection(let title):
            collectionTitleLabel.text = title
            collectionTitleLabel.font = .b_m_r
            collectionTitleLabel.textColor = .textColor
        case .arrowRightLeft, .arrowLeft:
            break
        }
    }
}

public extension NavigationBar {
    func setTitle(title: String) {
        collectionTitleLabel.text = title
    }
}
