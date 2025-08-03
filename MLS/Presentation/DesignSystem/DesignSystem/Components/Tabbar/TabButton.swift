import UIKit

import SnapKit

public final class TabButton: UIButton {
    // MARK: - Type
    private enum Constant {
        static let buttonSize: CGFloat = 64
        static let iconSize: CGFloat = 60
        static let spacing: CGFloat = 4
        static let padding: CGFloat = 11
    }

    // MARK: - Properties
    override public var isSelected: Bool {
        didSet {
            updateUI()
        }
    }

    // MARK: - Components
    private let iconView = UIImageView()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
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
        addSubview(iconView)
        addSubview(textLabel)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.size.equalTo(Constant.buttonSize).priority(.low)
        }

        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.padding)
            make.centerX.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(Constant.spacing)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constant.padding)
        }
    }

    func updateUI() {
        iconView.tintColor = isSelected ? .primary700 : .neutral300
        textLabel.textColor = isSelected ? .primary700 : .neutral700
        textLabel.font = .systemFont(ofSize: 10, weight: isSelected ? .semibold : .regular)
    }
}
