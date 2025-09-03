import SnapKit
import UIKit

public final class DictionaryDetailListView: UIStackView {
    // MARK: - Type
    private enum Constant {
        static let height: CGFloat = 50
        static let horizontalInset: CGFloat = 7
        static let iconSize: CGFloat = 24
        static let spacing: CGFloat = 9
    }

    // MARK: - Components
    private let mainLabel = UILabel()
    private let mainButtonLabel = UILabel()
    private lazy var mainButton = makeButton(label: mainButtonLabel)

    private let leftSpacer = UIView()
    private let rightSpacer = UIView()

    private let mainAdditionalLabel = UILabel()
    private let spacer = UIView()

    private let subLabel = UILabel()
    private let subButtonLabel = UILabel()
    private lazy var subButton = makeButton(label: subButtonLabel)

    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .neutral200
        return view
    }()

    // MARK: - init
    public init() {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = Constant.spacing
        alignment = .center

        addBaseViews()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DictionaryDetailListView {
    func addBaseViews() {
        addArrangedSubview(leftSpacer)
        addArrangedSubview(spacer)
        addArrangedSubview(rightSpacer)
        addSubview(underLine)
    }

    func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(Constant.height)
        }

        leftSpacer.snp.makeConstraints { make in
            make.width.equalTo(Constant.horizontalInset)
        }

        rightSpacer.snp.makeConstraints { make in
            make.width.equalTo(Constant.horizontalInset)
        }

        underLine.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    func makeButton(label: UILabel) -> UIButton {
        let button = UIButton()
        let icon = UIImageView(image: .rightArrow)

        button.addSubview(label)
        button.addSubview(icon)

        label.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }

        icon.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(Constant.iconSize)
        }

        return button
    }
}

extension DictionaryDetailListView {
    public func update(mainText: String? = nil, clickableMainText: String? = nil, additionalText: String? = nil, subText: String? = nil, clickableSubText: String? = nil) {
        let fixedViews: Set<UIView> = [leftSpacer, spacer, rightSpacer]
        arrangedSubviews
            .filter { !fixedViews.contains($0) }
            .forEach { removeArrangedSubview($0); $0.removeFromSuperview() }

        insertArrangedSubview(leftSpacer, at: 0)

        if let mainText = mainText {
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText)
            insertArrangedSubview(mainLabel, at: 1)
        }

        if let clickableMainText = clickableMainText {
            mainButtonLabel.attributedText = .makeStyledUnderlinedString(font: .sub_m_sb, text: clickableMainText)
            insertArrangedSubview(mainButton, at: arrangedSubviews.firstIndex(of: spacer) ?? 0)
        }

        if let additionalText = additionalText {
            mainAdditionalLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: additionalText)
            insertArrangedSubview(mainAdditionalLabel, at: arrangedSubviews.firstIndex(of: spacer) ?? 0)
        }

        if let subText = subText {
            subLabel.attributedText = .makeStyledString(font: .btn_s_r, text: subText)
            insertArrangedSubview(subLabel, at: arrangedSubviews.firstIndex(of: rightSpacer) ?? 0)
        }

        if let clickableSubText = clickableSubText {
            subButtonLabel.attributedText = .makeStyledUnderlinedString(font: .btn_s_r, text: clickableSubText)
            insertArrangedSubview(subButton, at: arrangedSubviews.firstIndex(of: rightSpacer) ?? 0)
        }
    }
}
