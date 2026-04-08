import UIKit

import SnapKit

public final class TabButton: UIButton {
    // MARK: - Type
    private enum Constant {
        static let spacing: CGFloat = 4
        static let iconSize: CGFloat = 24
    }

    // MARK: - Properties
    override public var isSelected: Bool {
        didSet {
            updateUI()
        }
    }

    // MARK: - Components
    private lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconView, textLabel])
        view.axis = .vertical
        view.spacing = Constant.spacing
        view.alignment = .center
        view.isUserInteractionEnabled = false
        return view
    }()

    private let iconView = UIImageView()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init
    public init(icon: UIImage, text: String) {
        super.init(frame: .zero)
        iconView.image = icon.withRenderingMode(.alwaysTemplate)
        textLabel.text = text
        addViews()
        setupConstraints()
        updateUI()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension TabButton {
    func addViews() {
        addSubview(contentView)
    }

    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.size.equalTo(Constant.iconSize)
        }
    }

    func updateUI() {
        iconView.tintColor = isSelected ? .primary700 : .neutral300
        textLabel.textColor = isSelected ? .primary700 : .neutral700
        textLabel.font = .systemFont(ofSize: 11, weight: isSelected ? .semibold : .regular)
    }
}
