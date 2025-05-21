import UIKit

import DesignSystem

internal import SnapKit

public final class OnBoardingInputView: UIView {
    // MARK: - Type
    private enum Constant {
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 40
        static let verticalSpacing: CGFloat = 28
        static let horizontalSpacing: CGFloat = 8
    }

    // MARK: - Components
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .makeStyledString(font: .h4, text: "현재 레벨과 직업을\n입력해주세요.", alignment: .left)
        label.numberOfLines = 2
        return label
    }()

    private let inputBox: InputBox = {
        let box = InputBox(label: "레벨", placeHodler: "1~200")
        box.textField.keyboardType = .numberPad
        return box
    }()
    
    private let dropDownBox = DropDownBox(label: "직업", placeHodler: "선택", menus: ["마법사", "전사", "궁수", "도적", "등등",])
    
    private let nextButton = CommonButton(style: .normal, title: "다음", disabledTitle: "")
    
    // MARK: - init
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#file), \(#function) Error")
    }
}

// MARK: - SetUp
private extension OnBoardingInputView {
    func addViews() {
        addSubview(descriptionLabel)
        addSubview(inputBox)
        addSubview(dropDownBox)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constant.verticalInset)
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
        }
        
        inputBox.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.verticalSpacing)
            make.leading.equalToSuperview().inset(Constant.horizontalInset)
            make.width.equalToSuperview().multipliedBy(0.5).inset((Constant.horizontalInset + (Constant.horizontalSpacing / 2)) / 2)
        }
        
        dropDownBox.snp.makeConstraints { make in
            make.top.equalTo(inputBox)
            make.leading.equalTo(inputBox.snp.trailing).offset(Constant.horizontalSpacing)
            make.trailing.equalToSuperview().inset(Constant.horizontalInset)
            make.width.equalToSuperview().multipliedBy(0.5).inset((Constant.horizontalInset + (Constant.horizontalSpacing / 2)) / 2)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constant.horizontalInset)
            make.bottom.equalToSuperview().inset(Constant.verticalInset)
        }
    }
    
    func configureUI() {
        addViews()
        setupConstraints()
        
        backgroundColor = .clear0
    }
}
