import UIKit

import SnapKit

public final class DictionaryDetailView: UIStackView {
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

    // MARK: - init
    public init(mainText: String? = nil, clickableMainText: String? = nil, additionalText: String? = nil, subText: String? = nil, clickableSubText: String? = nil) {
        super.init(frame: .zero)

        addViews(mainText: mainText, clickableMainText: clickableMainText, additionalText: additionalText, subText: subText, clickableSubText: clickableSubText)
        setupConstraints()
        configureUI(mainText: mainText, clickableMainText: clickableMainText, additionalText: additionalText, subText: subText, clickableSubText: clickableSubText)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetUp
private extension DictionaryDetailView {
    func addViews(mainText: String? = nil, clickableMainText: String? = nil, additionalText: String? = nil, subText: String? = nil, clickableSubText: String? = nil) {
        addArrangedSubview(leftSpacer)
        
        if mainText != nil {
            addArrangedSubview(mainLabel)
        }
        
        if clickableMainText != nil {
            addArrangedSubview(mainButton)
        }
        
        if additionalText != nil {
            addArrangedSubview(mainAdditionalLabel)
        }
        
        addArrangedSubview(spacer)
        
        if subText != nil {
            addArrangedSubview(subLabel)
        }
        
        if clickableSubText != nil {
            addArrangedSubview(subButton)
        }
        
        addArrangedSubview(rightSpacer)
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
    }

    func configureUI(mainText: String? = nil, clickableMainText: String? = nil, additionalText: String? = nil, subText: String? = nil, clickableSubText: String? = nil) {
        spacing = Constant.spacing
        
        if let mainText = mainText {
            mainLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: mainText)
        }
        
        if let clickableMainText = clickableMainText {
            mainButtonLabel.attributedText = .makeStyledUnderlinedString(font: .sub_m_sb, text: clickableMainText)
        }
        
        if let additionalText = additionalText {
            mainAdditionalLabel.attributedText = .makeStyledString(font: .sub_m_sb, text: additionalText)
        }
        
        if let subText = subText {
            subLabel.attributedText = .makeStyledString(font: .btn_s_r, text: subText)
        }
        
        if let clickableSubText = clickableSubText {
            subButtonLabel.attributedText = .makeStyledUnderlinedString(font: .btn_s_r, text: clickableSubText)
        }
    }
    
    func makeButton(label: UILabel) -> UIButton {
            let button = UIButton()
            let icon = UIImageView(image: .rightArrow)

            button.addSubview(label)
            button.addSubview(icon)

            label.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
            }

            icon.snp.makeConstraints { make in
                make.leading.equalTo(label.snp.trailing)
                make.trailing.centerY.equalToSuperview()
                make.size.equalTo(Constant.iconSize)
            }

            return button
        }
}
