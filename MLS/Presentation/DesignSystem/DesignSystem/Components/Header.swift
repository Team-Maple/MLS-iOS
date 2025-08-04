import UIKit

import SnapKit

public final class Header: UIStackView {
    // MARK: - Type
    public enum HeaderStyle {
        case main
        case filter

        public var titleFont: UIFont? {
            switch self {
            case .main:
                return .h_xxxl_sb
            case .filter:
                return .h_xl_sb
            }
        }

        var icons: [UIImage] {
            switch self {
            case .main:
                return [.search, .bell]
            case .filter:
                return [.largeX]
            }
        }
    }

    private enum Constant {
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 16
        static let mainTypeHeight: CGFloat = 44
    }

    // MARK: - Properties
    public let style: HeaderStyle

    // MARK: - Components
    public let titleLabel = UILabel()
    private let spacer = UIView()
    public let firstIconButton = UIButton()
    public let secondIconButton = UIButton()

    // MARK: - init
    public init(style: HeaderStyle, title: String) {
        titleLabel.attributedText = .makeStyledString(font: .h_xxxl_sb, text: title)
        self.style = style
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension Header {
    func addViews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(spacer)
        addArrangedSubview(firstIconButton)
        if style == .main {
            addArrangedSubview(secondIconButton)
        }
    }

    func setupConstraints() {
        if style == .main {
            snp.makeConstraints { make in
                make.height.equalTo(Constant.mainTypeHeight)
            }
        }

        firstIconButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }

        secondIconButton.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }
    }

    func configureUI() {
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: Constant.spacing, bottom: 0, right: Constant.spacing)
        axis = .horizontal
        spacing = Constant.spacing
        titleLabel.font = style.titleFont
        titleLabel.textColor = .textColor
        firstIconButton.setImage(style.icons[0], for: .normal)
        if style == .main {
            secondIconButton.setImage(style.icons[1], for: .normal)
        }
    }
}
