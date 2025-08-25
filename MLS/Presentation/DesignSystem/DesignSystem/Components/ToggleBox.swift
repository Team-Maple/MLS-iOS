import UIKit

import SnapKit

public final class ToggleBox: UIView {
    // MARK: - Type
    enum Constant {
        static let margin: CGFloat = 20
        static let toggleWidth: CGFloat = 51
        static let toggleHeight: CGFloat = 31
        static let radius: CGFloat = 8
        static let height: CGFloat = 60
    }

    // MARK: - Components
    private let textLabel = UILabel()

    public let toggle: UISwitch = {
        let button = UISwitch()
        button.thumbTintColor = .whiteMLS
        button.onTintColor = .primary700
        button.isOn = false
        return button
    }()

    public init(text: String?) {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
        configureUI(text: text)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension ToggleBox {
    func addViews() {
        addSubview(textLabel)
        addSubview(toggle)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        textLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.margin)
            make.leading.equalToSuperview().inset(Constant.margin)
        }

        toggle.snp.makeConstraints { make in
            make.leading.equalTo(textLabel.snp.trailing)
            make.trailing.centerY.equalToSuperview().inset(Constant.margin)
            make.width.equalTo(Constant.toggleWidth)
            make.height.equalTo(Constant.toggleHeight)
        }
    }

    func configureUI(text: String?) {
        textLabel.attributedText = .makeStyledString(font: .sub_m_b, text: text, alignment: .left)
        backgroundColor = .neutral100
        layer.cornerRadius = Constant.radius
    }
}
