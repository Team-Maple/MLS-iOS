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
                return .heading3SemiBold
            case .filter:
                return .heading5SemiBold
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
    public let firstIconView = UIButton()
    public let secondIconView = UIButton()

    // MARK: - init
    public init(style: HeaderStyle) {
        self.style = style
        super.init(frame: .zero)

        addViews()
        setupConstraints()
        configureUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension Header {
    func addViews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(spacer)
        addArrangedSubview(firstIconView)
        if style == .main {
            addArrangedSubview(secondIconView)
        }
    }

    func setupConstraints() {
        if style == .main {
            snp.makeConstraints { make in
                make.height.equalTo(Constant.mainTypeHeight)
            }
        }

        firstIconView.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }

        secondIconView.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }
    }

    func configureUI() {
        axis = .horizontal
        spacing = Constant.spacing
        titleLabel.font = style.titleFont
        titleLabel.textColor = .textColor
        firstIconView.setImage(style.icons[0], for: .normal)
        if style == .main {
            secondIconView.setImage(style.icons[1], for: .normal)
        }
    }
}
